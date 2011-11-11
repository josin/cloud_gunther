# == Schema Information
# Table name: images
# Fields: id, title, description, cloud_engine_id, launch_params, 
#         start_up_script, created_at, updated_at, #

class Image < ActiveRecord::Base
  belongs_to :cloud_engine
  
  serialize :launch_params
  
  # attr_accessible :title, :description, :cloud_engine_id, :launch_params, :start_up_script
  
  validates_presence_of :cloud_engine_id, :title
  
  INSTANCE_TYPES = %w{m1.small c1.medium m1.large m1.xlarge c1.xlarge}
  
  def describe_image!
    connection = self.cloud_engine.connect!
    connection.ec2_describe_images("ImageId" => self.launch_params["image_id"]).first
  end
  
  include ParamsReader
  def image_id; read_from_params(:launch_params, "image_id"); end
  def instance_type; read_from_params(:launch_params, "instance_type"); end
  def availability_zone; read_from_params(:launch_params, "availability_zone"); end
  
  def start_up_script_for_ssh(task)
    lines = []
    
    self.start_up_script.each_line do |line|
      # RegExpresion match everything except new line characters
      lines << line.match(/.*[^\r\n]/)[0] unless line.blank?
    end
    
    ssh_cmd = lines.to_sentence(:words_connector => ";", :two_words_connector => ";", :last_word_connector => ";")
    return MacroProcessor.process_macros(ssh_cmd, task)
  end
end
