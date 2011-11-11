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
  def key_name; read_from_params(:params, "key_name"); end
  def availability_zones_info_cmd; read_from_params(:params, "availability_zones_info_cmd"); end
  
  def eucalyptus?
    self.engine_type == CloudEngine::ENGINE_TYPES[:eucalyptus]
  end
  
  def aws?
    self.engine_type == CloudEngine::ENGINE_TYPES[:aws]
  end

  def fetch_availability_zones_info
    macro_processed_cmd = MacroProcessor.process_macros(self.availability_zones_info_cmd, self, CloudEngine)
    VerboseAvailabilityZonesInfo.get_info(macro_processed_cmd) if self.eucalyptus?
  end

  def availability_zones
    self.connect!.describe_availability_zones
  end
  
  def describe_instances(instances = [])
    self.connect!.describe_instances(instances)
  rescue Exception => e
    logger.error { "Could not connect to cloud engine id: #{task.cloud_engine.id}. Reason: #{e}" }
  end
  
  def terminate_instance(instance = nil)
    return if instance.blank?
    self.connect!.terminate_instances([instance])
  rescue Exception => e
    logger.error { "Could not connect to cloud engine id: #{task.cloud_engine.id}. Reason: #{e}" }
  end
end
