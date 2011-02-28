# == Schema Information
# Table name: algorithms
# Fields: id, name, group, user_id, description, 
#         launch_params, created_at, updated_at, #

class Algorithm < ActiveRecord::Base
  belongs_to :user
  
  has_many :algorithm_binaries, :dependent => :destroy
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :user_id, :on => :create

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
end
