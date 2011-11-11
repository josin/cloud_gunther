require 'spec_helper'

describe InstancesDispatcher do
  
  let(:image) { mock_model(Image, :launch_params => {"image_id" => "emi-123", "key_pair" => "kp"}).as_null_object }
  let(:cloud_engine) { mock_model(CloudEngine).as_null_object }
  let(:task) { mock_model(Task, :image => image, :cloud_engine => cloud_engine, :task_params => {"instances_count" => 3}).as_null_object }                  
  let(:ic) { InstancesDispatcher.new(task) }
  let(:connection) { mock("connection", :describe_instances => [{:aws_state => "pending", :aws_instance_id => "i123"}]).as_null_object }
  let(:instances) { [{:aws_instance_id => "i-123456789", :aws_state => "pending"}] }

  before(:each) do
    # ic.stub(:connection => connection)
  end
  
  describe "initialization" do
    it "assigns given task object in local field" do
      ic.task.should be(task)
      ic.instances.should be_empty
    end
  end
  
  describe "logger" do
    it "reuses Rails logger" do
      ic.send(:logger).should be(Rails.logger)
    end
  end
  
  describe "run instances" do
    it "calls all methods used for launch and init instances" do
      AppConfig.stub(:config).and_return({:configure_instances => true})
      
      ic.should_receive(:launch_instances)
      ic.should_receive(:wait_until_instances_ready)
      ic.should_receive(:prepare_instances)
      ic.should_receive(:run_task)
      
      ic.run_instances.should be_nil
    end
    
    it "launches instances when appconfig disables configure_instances" do
      AppConfig.stub(:config).and_return({:configure_instances => false})
      
      ic.should_receive(:launch_instances)
      ic.should_not_receive(:wait_until_instances_ready)
      
      ic.run_instances.should be_nil
    end
  end
  
  describe "launch instances" do
    it "launches given specified number of instances" do
      cloud_engine.should_receive(:connect!).and_return(connection)
      
      connection.should_receive(:launch_instances).with("emi-123", 
        hash_including(:addressing_type => "private", :key_name => "kp", :user_data => instance_of(String))).
        and_return(instances)

      ic.send(:launch_instances)
      task.task_params.should have_key("instances")
      task.task_params["instances"].should include(instances.first[:aws_instance_id])
    end
  end
  
  describe "wait until instances ready" do
    it "waits until instances are ready" do
      ic.should_receive(:instances_ready?).exactly(3).and_return(false)
      ic.should_receive(:instances_ready?).and_return(true)
      
      ic.should_receive(:sleep).at_least(3)
      
      ic.send(:wait_until_instances_ready)
    end
    
    it "raises error when until given period of time instances are not ready" do
      ic.should_receive(:instances_ready?).at_most(100).and_return(false)
      ic.should_receive(:sleep).at_least(1).at_most(100)
      
      lambda { ic.send(:wait_until_instances_ready) }.should raise_error
    end
  end
  
  describe "instances ready?" do
    before(:each) do
      ic.connection = connection
      ic.connection.should_not be_nil
    end
    
    it "checks instances state - only pending" do
      connection.should_receive(:describe_instances).and_return([{:aws_state => "pending"}])
      ic.send(:instances_ready?).should be_false
    end

    it "checks instances state - pending and running" do
      connection.should_receive(:describe_instances).and_return([{:aws_state => "running"}, {:aws_state => "pending"}, {:aws_state => "running"}])
      ic.send(:instances_ready?).should be_false
    end

    it "checks instances state" do
      connection.should_receive(:describe_instances).and_return([{:aws_state => "running"}])
      ic.send(:instances_ready?).should be_true
    end
  end
  
  describe "prepare instances" do
    it "fails" do
      pending
    end
  end
  
  describe "run task" do
    it "fails" do
      pending
    end
  end
  
  describe "create user data" do
    before(:each) do
      AppConfig.should_receive(:amqp_config).and_return({})
    end
    
    it "should return string with serialized user data" do
      ic.send(:create_user_data).should be_a(String)
    end
    
    it "should be possible to deserializate user data from yaml" do
      data = ic.send(:create_user_data)
      data_hash = YAML::load(data)
      data_hash.should be_a(Hash)
      data_hash.should have_key(:amqp_config)
      data_hash.should have_key(:input_queue)
      data_hash.should have_key(:output_queue)
    end
  end
end