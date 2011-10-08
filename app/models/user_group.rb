# == Schema Information
# Table name: user_groups
# Fields: id, name, permissions_store, priority, created_at, 
#         updated_at, #

class UserGroup < ActiveRecord::Base
  
  attr_accessible :id, :name, :permissions_store, :priority, :created_at, :updated_at

  has_many :user_group_assocs
  has_many :users, :through => :user_group_assocs
  
end
