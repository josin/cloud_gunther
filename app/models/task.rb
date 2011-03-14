# == Schema Information
# Table name: tasks
# Fields: id, started_at, finished_at, params, inputs, 
#         state, user_id, algorithm_binary_id, created_at, updated_at, 
#         #

require "popen4"

class Task < ActiveRecord::Base
  extend ActiveModel::Callbacks
  before_save :action_before_save
  # after_save :action_after_save
  
  # attr_accessible :id, :started_at, :finished_at, :params, :inputs, :state, :user_id, :algorithm_binary_id, :created_at, :updated_at
  
  belongs_to :user
  belongs_to :algorithm_binary
  has_one :algorithm, :through => :algorithm_binary
  
  has_many :outputs
  validates_presence_of :algorithm_binary_id #, :inputs :params
  validates_presence_of :user_id, :on => :create
  validates_presence_of :state, :on => :save
  
  def run!(*args)
    self.started_at = Time.now
    
    task_home_dir = "#{::Rails.root}/tmp/tasks/#{self.id}/"

    # download file into tmp folder
    FileUtils.mkpath(task_home_dir)
    FileUtils.cp(self.algorithm_binary.attachment.data.path, task_home_dir)

    # run appropriate task
    stdout, stderr = "", ""
    cmd = "cd #{task_home_dir} && #{self.algorithm_binary.launch_params}"
    status = POpen4::popen4(cmd) do |out, err|
      out.each_line { |line| stdout << line }
      err.each_line { |line| stderr << line }
    end
    # save outputs
    output = self.outputs.new
    output.stdout = stdout
    output.stderr = stderr
    output.save
      
    # delete files from tmp
    FileUtils.rm_rf(task_home_dir)

    self.state = "finished"
    self.finished_at = Time.now
    self.save
  end
  
  private
  def action_before_save
    self.state = "new" if self.state.blank?
  end
  
  def action_after_save
    # self.delay.run!(self)
  end
end
