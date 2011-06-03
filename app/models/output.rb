# == Schema Information
# Table name: outputs
# Fields: id, task_id, stdout, stderr, created_at, 
#         updated_at, params, #

class Output < ActiveRecord::Base
  belongs_to :task
  
  validates_presence_of :task_id
  
  serialize :params
end
