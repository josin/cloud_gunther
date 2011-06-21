# == Schema Information
# Table name: tasks
# Fields: id, started_at, finished_at, params, inputs, 
#         state, user_id, algorithm_binary_id, created_at, updated_at, 
#         cloud_engine_id, task_params, image_id, #

require "builder/xmlmarkup"

class Task < ActiveRecord::Base
  STATES = {
      :new => "new",
      :ready => "ready",
      :running => "running",
      :finished => "finished",
      :canceled => "canceled",
      :failed => "failed",
  }

  before_save :action_before_save

  # attr_accessible :id, :started_at, :finished_at, :params, :inputs, :state, :user_id, :algorithm_binary_id, :created_at, :updated_at

  belongs_to :user
  belongs_to :algorithm_binary
  has_one :algorithm, :through => :algorithm_binary
  belongs_to :cloud_engine
  belongs_to :image
  
  has_one :inputs_file, :as => :attachable, :dependent => :destroy, :conditions => "attachment_type = 'inputs_file'"
  accepts_nested_attributes_for :inputs_file, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }

  has_one :params_file, :as => :attachable, :dependent => :destroy, :conditions => "attachment_type = 'params_file'"
  accepts_nested_attributes_for :params_file, :allow_destroy => true, :reject_if => proc { |obj| obj.blank? }

  has_many :outputs
  validates_presence_of :algorithm_binary_id #, :inputs :params
  validates_presence_of :user_id, :on => :create
  validates_presence_of :state, :on => :save

  scope :running, where((:state - [STATES[:new], STATES[:finished]]))

  serialize :task_params
  
  attr_accessor :instance_id # attr helper for macro processing
  
  def run(*args)
    options = {
        :launch_cmd => self.algorithm_binary.prepare_launch_cmd,
        :instances_count => self.task_params[:instances_count],
        :task_id => self.id,
    }
    options.merge!(args.extract_options!)
    
    amqp_config = AmqpConfig.config
    bunny = Bunny.new(amqp_config)
    status = bunny.start
    raise "Could not connect to MQ broker." unless status == :connected
    queue = bunny.queue("inputs")
    
    self.task_params[:instances_count].to_i.times do |index|
      self.instance_id = (index + 1)
      logger.debug { "Processing macros for instance id: #{self.instance_id}" }

      launch_cmd = MacroProcesor.process_macros(options[:launch_cmd].clone, self)
      
      task_options = options.dup
      task_options.merge!(:instance_id => self.instance_id, :launch_cmd => launch_cmd)
      
      task_xml = task2xml(task_options)
      logger.debug { "Task's XML: #{task_xml}" }
      queue.publish task_xml
    end

    # run instances
    if AppConfig.config[:start_instances]
      instances_controller = InstancesDispatcher.new(self)
      instances_controller.run_instances
    end
    
    self.update_attribute(:state, STATES[:running])
  rescue Exception => e
    self.update_attribute(:state, STATES[:failed])
    raise e
    # logger.error { "Running task #{self.id} failed due to: #{e.message}" }
    # self.outputs.create(:stderr => e.message)
  end
  handle_asynchronously :run

  private

  # Returns xml of task definition with all information necessary for running it on cloud.
  #
  # ==== Examples
  # <?xml version="1.0" encoding="UTF-8"?>
  # <task id="">
  #   <task_params instance_id="" instances_count="" />
  # 	<alg_binary url="" filename="" launch_cmd="" />
  # 	<inputs />
  # </task>
  def task2xml(*args)
    options = {
        :instance_id => 1,
    }
    options.merge!(args.extract_options!)

    xml = ::Builder::XmlMarkup.new
    xml.instruct!

    xml.task(:id => options[:task_id]) do |task|
      task.task_params(:instance_id => options[:instance_id], :instances_count => options[:instances_count])

      task.alg_binary({
        :filename => options[:algorithm_filename].presence,
        :launch_cmd => options[:launch_cmd].presence,
        :url => options[:algorithm_url].presence
      })

      task.inputs() do |inputs|
      end
    end

    xml.target!
  end

  def action_before_save
    self.state = STATES[:new] if self.state.blank?
  end

end
