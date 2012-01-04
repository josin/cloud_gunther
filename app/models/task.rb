# == Schema Information
# Table name: tasks
# Fields: id, started_at, finished_at, params, inputs, 
#         state, user_id, algorithm_binary_id, created_at, updated_at, 
#         cloud_engine_id, task_params, image_id, priority, attempts, 
#         error_msg, failed_at, #

require "builder/xmlmarkup"

class Task < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  
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

  scope :running, where(:state => STATES[:running])

  serialize :task_params
  
  include ParamsReader
  def instances_count; read_from_params(:task_params, "instances_count"); end
  def instance_type; read_from_params(:task_params, "instance_type"); end
  def zone_name; read_from_params(:task_params, "zone_name"); end
  def instances; read_from_params(:task_params, "instances"); end
  def run_params; read_from_params(:task_params, "run_params"); end
  
  attr_accessor :instance_id # attr helper for macro processing
  
  def run(*args)
    options = {
        :launch_cmd => self.algorithm_binary.prepare_launch_cmd,
        :instances_count => self.instances_count,
        :task_id => self.id,
    }
    
    if self.algorithm_binary.attachment
      options[:algorithm_url] = url_for(attachment_path(:id => self.algorithm_binary.attachment.id,
                                                        :auth_token => self.user.authentication_token,
                                                        :host => AppConfig.config[:host],
                                                        :only_path => false))
      options[:algorithm_filename] = self.algorithm_binary.attachment.data_file_name
    end    
    
    self.task_params["run_params"] = options
    self.save
    
    amqp_config = AppConfig.amqp_config
    bunny = Bunny.new(amqp_config)
    status = bunny.start
    raise "Could not connect to MQ broker." unless status == :connected
    bunny.queue(self.task_queue_name)
    
    self.instances_count.to_i.times do |index|
      self.instance_id = (index + 1)
      logger.info { "Processing macros for instance id: #{self.instance_id}" }

      launch_cmd = MacroProcessor.process_macros(options[:launch_cmd].clone, self)
      
      task_options = options.dup
      task_options.merge!(:instance_id => self.instance_id, :launch_cmd => launch_cmd)
      
      task_xml = task2xml(task_options)
      logger.info { "Task's XML: #{task_xml}" }
      bunny.exchange('').publish task_xml, :key => self.task_queue_name, :routing_key => self.task_queue_name
    end

    # run instances
    if AppConfig.config[:start_instances]
      instances_controller = InstancesDispatcher.new(self)
      instances_controller.run_instances
    end
  rescue Exception => e
    self.failure! e.message
    self.cloud_engine.terminate_instance(self.instances)
    logger.error { "Running task #{self.id} failed due to: #{e.message}\n#{e.backtrace.join("\n")}" }
  end
  
  def task_queue_name
    # "task-#{self.id}"
    "inputs"
  end
  
  def fetch_instances_info
    unless self.instances.blank?
      instances_info = self.cloud_engine.describe_instances(self.instances) 
    end
    
    instances_info || []
  end
  
  def failure!(error_msg = "", failed_at = Time.now)
    self.update_attributes({ :state => STATES[:failed], :error_msg => error_msg, :failed_at => failed_at })
  end
  
  def finish!
    self.update_attributes({:finished_at => Time.now, :state => Task::STATES[:finished]})
  end
  
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
