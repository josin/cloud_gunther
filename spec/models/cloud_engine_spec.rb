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
end
