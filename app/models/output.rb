# == Schema Information
# Table name: outputs
# Fields: id, task_id, output, created_at, updated_at, 
#         #

class Output < ActiveRecord::Base
  belongs_to :task, :class_name => "Task", :foreign_key => "task_id"
  
  validates_presence_of :task_id, :output
end
