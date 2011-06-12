require 'spec_helper'
# 
# def connect!
#   @connection = nil
# 
#   options = {}
#   options = { :endpoint_url => self.endpoint_url, :eucaliptus => true } if self.engine_type == "Eucaliptus"
# 
#   @connection = RightAws::Ec2.new self.access_key, self.secret_access_key, options
# end
# 
describe CloudEngine do
  let(:cloud_engine) { CloudEngine.new(:access_key => "foo", :secret_access_key => "bar") }
  
  describe "connect" do
    let(:connection) { mock("connection") }
    
    it "creates a new connection to eucaliptus" do
      cloud_engine.stub(:engine_type => "Eucaliptus")
      RightAws::Ec2.should_receive(:new).with("foo", "bar", hash_including(:endpoint_url => nil, :eucaliptus => true))
      cloud_engine.connect!
    end
    
    it "creates a new connection to AWS" do
      cloud_engine.stub(:engine_type => "AWS")
      RightAws::Ec2.should_receive(:new).with("foo", "bar", instance_of(Hash))
      cloud_engine.connect!
    end
  end
end
