# == Schema Information
# Table name: images
# Fields: id, name, description, cloud_engine_id, image_type, 
#         created_at, updated_at, #

class Image < ActiveRecord::Base
  belongs_to :cloud_engine
  
end
