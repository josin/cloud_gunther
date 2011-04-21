# == Schema Information
# Table name: tasks
# Fields: id, started_at, finished_at, params, inputs, 
#         state, user_id, algorithm_binary_id, created_at, updated_at, 
#         #

require "popen4"
require "builder/xmlmarkup"

MACRO_REGEXP = /\{{2}(\w+)\}{2}/

class Task < ActiveRecord::Base
  before_save :action_before_save
  
  # attr_accessible :id, :started_at, :finished_at, :params, :inputs, :state, :user_id, :algorithm_binary_id, :created_at, :updated_at
  
  belongs_to :user
  belongs_to :algorithm_binary
  has_one :algorithm, :through => :algorithm_binary
  
  has_many :outputs
  validates_presence_of :algorithm_binary_id #, :inputs :params
  validates_presence_of :user_id, :on => :create
  validates_presence_of :state, :on => :save
  
  scope :running, where((:state - ["new", "finished"]))
  
  serialize :params
  
  def run!(*args)
    options = args.extract_options!
    
    task_xml = task2xml
    logger.debug { "Task's XML: #{task_xml}" }
    MQ.new.queue("inputs").publish(task2xml(self))
    
    self.state = "ready"
    self.save
    # TODO: validation
    # TODO: run instances
    # TODO: send task xml description to MQ broker
  end
  
  # Returns xml of task definition with all information necessary for running it on cloud.
  #
  # ==== Examples
  # <?xml version="1.0" encoding="UTF-8"?>
  # <task id="">
  #   <task_params instance_id="" instances_count="" />
  # 	<alg_binary url="" filename="" launch_cmd="" />
  # 	<inputs />
  # </task>
  def task2xml(task)
    xml = ::Builder::XmlMarkup.new
    xml.instruct!
    
    xml.task(:id => task.id) do |task|
      task.task_params(:instance_id => "", :instances_count => "")
      task.alg_binary(:url => "", :filename => "", :launch_cmd => "") do |alg_binary|
      end
      
      task.inputs() do |inputs|
      end
    end
    
    xml.target!
  end
  
  
  # def run!(*args)
  #   options = args.extract_options!
  #   
  #   self.started_at = Time.now
  #   
  #   task_home_dir = "#{::Rails.root}/tmp/tasks/#{self.id}/"
  # 
  #   # download file into tmp folder
  #   FileUtils.mkpath(task_home_dir)
  #   FileUtils.cp(self.algorithm_binary.attachment.data.path, task_home_dir)
  # 
  #   # prepare run command
  #   launch_cmd = self.algorithm_binary.prepare_launch_cmd
  #   
  #   launch_cmd.gsub!(MACRO_REGEXP) do |m|
  #     all, macro = $&, $1
  #     case macro
  #       when "BINARY"
  #         self.algorithm_binary.attachment.data_file_name
  #       when "INPUTS"
  #         self.inputs
  #     end
  #   end
  #   
  #   # run appropriate task
  #   stdout, stderr = "", ""
  #   cmd = "cd #{task_home_dir} && #{launch_cmd}"
  #   status = POpen4::popen4(cmd) do |out, err|
  #     out.each_line { |line| stdout << line }
  #     err.each_line { |line| stderr << line }
  #   end
  #   # save outputs
  #   output = self.outputs.new
  #   output.stdout = stdout
  #   output.stderr = stderr
  #   output.save
  #     
  #   # delete files from tmp
  #   FileUtils.rm_rf(task_home_dir)
  # 
  #   self.state = "finished"
  #   self.finished_at = Time.now
  #   self.save
  # end
  
  private
  def action_before_save
    self.state = "new" if self.state.blank?
  end
  
end
