require 'spec_helper'

describe CloudEngine do
  let(:cloud_engine) { CloudEngine.new(:access_key => "foo", :secret_access_key => "bar") }
  
  describe "engine types" do
    it "engine_types constant should include eucalyptus and aws" do
      engine_types = CloudEngine::ENGINE_TYPES
      engine_types.should include(:eucalyptus => "Eucalyptus", :aws => "AmazonWS")
    end
  end
  
  describe "connect" do
    let(:connection) { mock("connection") }
    
    it "creates a new connection to eucaliptus" do
      cloud_engine.stub(:engine_type => CloudEngine::ENGINE_TYPES[:eucalyptus])
      RightAws::Ec2.should_receive(:new).with("foo", "bar", hash_including(:endpoint_url => nil, :eucaliptus => true))
      cloud_engine.connect!
    end
    
    it "creates a new connection to AWS" do
      cloud_engine.stub(:engine_type => CloudEngine::ENGINE_TYPES[:aws])
      RightAws::Ec2.should_receive(:new).with("foo", "bar", instance_of(Hash))
      cloud_engine.connect!
    end
  end
  
  describe "cloud engine type" do
    it "is eucalyptus?" do
      cloud_engine.engine_type = CloudEngine::ENGINE_TYPES[:eucalyptus]
      cloud_engine.eucalyptus?.should be_true
    end
    
    it "is aws?" do
      cloud_engine.engine_type = CloudEngine::ENGINE_TYPES[:aws]
      cloud_engine.aws?.should be_true
    end
  end

  describe "availability zones" do
    it "fetchs availability zones using cloud connecter" do
      connection = mock("cloud connection")
      cloud_engine.should_receive(:connect!).and_return(connection)
      connection.should_receive(:describe_availability_zones).and_return(%w(us-west1 us-east1))
      cloud_engine.availability_zones.should_not be_empty
    end
    
    it "fetchs availability zones info using command line tool" do
      cmd = "euca-describe-availability-zones"
      cloud_engine.params = { "availability_zones_info_cmd" => cmd }
      cloud_engine.engine_type = CloudEngine::ENGINE_TYPES[:eucalyptus]
      
      MacroProcessor.should_receive(:process_macros).with(cmd, cloud_engine, cloud_engine.class).and_return(cmd)
      VerboseAvailabilityZonesInfo.should_receive(:get_info).with(cmd).and_return(["availablity", "zones", "info"])
      
      cloud_engine.fetch_availability_zones_info.should_not be_empty
    end
  end

  describe "describe instances" do
    it "is pending" do
      pending
    end
  end
  
  describe "terminate instances" do
    it "is pending" do
      pending
    end
  end
end
