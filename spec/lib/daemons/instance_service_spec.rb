require 'spec_helper'

describe Daemons::InstanceService do
  
  let(:bunny) { mock("bunny", :start => "connected") }
  let(:queue) { mock("queue", :publish => true, :pop => {:payload => "i-123456"}) }
  let(:connection) { mock("connection") }
  
  describe "run method" do
    pending
    # it "runs instance service job" do
    #   Bunny.should_receive(:new).and_return(bunny)
    #   bunny.should_receive(:queue).with("instance_service").and_return(queue)
    #   CloudEngine.stub_chain(:where, :first, :connect!).and_return(connection)
    #   
    #   # connection.should_receive(:terminate_instances).with(["i-123456"])
    # 
    #   lambda { Daemons::InstanceService.run }.should_not raise_error
    # end
  end
end