require 'spec_helper'

describe Task do
  let(:task) { Task.new(:id => 1) }
  
  it "tasks queue name" do
    task.task_queue_name.should match(/#{task.id}/)
  end
  
  describe "fetch instances info" do
    it "returns empty array when no instances are specified" do
      task.fetch_instances_info.should be_blank
    end
    
    it "returns instances description" do
      task.task_params = { "instances" => ["i-123456"] }
      task.stub_chain(:cloud_engine, :describe_instances).and_return(["instances", "description"])
      task.fetch_instances_info.should_not be_blank
      task.fetch_instances_info.should eq(["instances", "description"])
    end
  end
  
  describe "run" do
    pending
  end

  describe "task2xml" do
    pending
  end
end
