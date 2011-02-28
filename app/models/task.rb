# == Schema Information
# Table name: tasks
# Fields: id, started_at, finished_at, params, inputs, 
#         state, user_id, algorithm_binary_id, created_at, updated_at, 
#         #

class Task < ActiveRecord::Base
  extend ActiveModel::Callbacks
  before_save :action_before_save
  
  belongs_to :user
  belongs_to :algorithm_binary
  has_one :algorithm, :through => :algorithm_binary
  
  has_one :ouput
  validates_presence_of :algorithm_binary_id #, :inputs :params
  validates_presence_of :user_id, :on => :create
  validates_presence_of :state, :on => :save
  
  private
  def action_before_save
    self.state ||= "new"
  end
  
end
