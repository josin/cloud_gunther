# == Schema Information
# Table name: images
# Fields: id, title, description, cloud_engine_id, launch_params, 
#         start_up_script, created_at, updated_at, #

class Image < ActiveRecord::Base
  belongs_to :cloud_engine
  
  serialize :launch_params
  
  # attr_accessible :title, :description, :cloud_engine_id, :launch_params, :start_up_script
  
  validates_presence_of :cloud_engine_id, :title

  def describe_image!
    connection = self.cloud_engine.connect!
    connection.ec2_describe_images("ImageId" => self.launch_params[:image_id]).first
  end
  
  INSTANCE_TYPES = %w{m1.small c1.medium m1.large m1.xlarge c1.xlarge}
end
