require 'spec_helper'

describe Task do
  describe "run" do
    it "pending" do
      pending
    end
  end

  describe "task queue name" do
    it "pending" do
      pending
    end
  end
  
  describe "fetch instances info" do
    let(:task) { Task.new }
    
    it "returns empty array when no instances are specified" do
      task.fetch_instances_info.should be_blank
    end
    
    it "returns instances description" do
      task.task_params = { :instances => ["i-123456"] }
      task.stub_chain(:cloud_engine, :describe_instances).and_return(["instances", "description"])
      task.fetch_instances_info.should_not be_blank
      task.fetch_instances_info.should eq(["instances", "description"])
    end
  end

  describe "task2xml" do
    it "pending" do
      pending
    end
  end
end
