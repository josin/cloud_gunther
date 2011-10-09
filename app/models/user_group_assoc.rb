# == Schema Information
# Table name: user_group_assocs
# Fields: id, user_group_id, user_id, created_at, updated_at, 
#         #

class UserGroupAssoc < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :user_group

end
