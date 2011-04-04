# == Schema Information
# Table name: cloud_engines
# Fields: id, title, engine_type, access_key, secret_access_key, 
#         endpoint_url, created_at, updated_at, #

class CloudEngine < ActiveRecord::Base
  
  ENGINE_TYPES = %w{AWS Eucaliptus}
  
  has_many :images
  
  
  
  def connect!
    @connection = nil
  
    options = {}
    options = { :endpoint_url => self.endpoint_url, :eucaliptus => true } if self.engine_type == "Eucaliptus"

    @connection = RightAws::Ec2.new self.access_key, self.secret_access_key, options
  end
  
end
