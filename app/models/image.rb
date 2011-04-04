# == Schema Information
# Table name: images
# Fields: id, title, description, cloud_engine_id, image_type, 
#         created_at, updated_at, #

class Image < ActiveRecord::Base
  belongs_to :cloud_engine
  
  validates_presence_of :cloud_engine_id, :name, :image_type


  def describe_image!
    @connection = self.cloud_engine.connect!
    @connection.ec2_describe_images("ImageId" => self.image_type).first
  end
  
end
