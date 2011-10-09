# == Schema Information
# Table name: user_groups
# Fields: id, name, permissions_store, priority, created_at, 
#         updated_at, #

class UserGroup < ActiveRecord::Base
  
  has_many :user_group_assocs
  has_many :users, :through => :user_group_assocs
  
  validates_presence_of :name
  validates_numericality_of :priority
  
  
  attr_reader :user_tokens
  def user_tokens=(ids)
    self.user_ids = ids.split(",")
  end
  
end
