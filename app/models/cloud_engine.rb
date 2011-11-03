# == Schema Information
# Table name: cloud_engines
# Fields: id, title, engine_type, access_key, secret_access_key, 
#         endpoint_url, created_at, updated_at, params, #

class CloudEngine < ActiveRecord::Base

  ENGINE_TYPES = { :eucalyptus => "Eucalyptus", :aws => "AmazonWS" }
  
  attr_reader :connection

  has_many :images
  
  serialize :params
  
  def connect!
    @connection = nil
  
    options = {}
    options = { :endpoint_url => self.endpoint_url, :eucaliptus => true } if self.engine_type == ENGINE_TYPES[:eucalyptus]

    @connection = RightAws::Ec2.new self.access_key, self.secret_access_key, options
  end
  
  include ParamsReader
  def key_name; read_from_params(:params, :key_name); end
  def availability_zones_info; read_from_params(:params, :availability_zones_info); end
  
  def availability_zones_info_cmd
    MacroProcesor.process_macros(self.availability_zones_info, self, CloudEngine)
  end

end
