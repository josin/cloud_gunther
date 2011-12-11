require 'spec_helper'

describe Task do
  fixtures :tasks
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
  
  describe "failure! method" do
    let(:task) { tasks(:task_1) }
    
    before(:each) do
      [:error_msg, :failed_at].each { |field| task.send(field).should be_blank }
      task.state.should_not eq(Task::STATES[:failed])
    end

    it "should move task to failed stated and associated time and error msg" do
      task.failure! "foobar"
      task.error_msg.should == "foobar"
      task.failed_at.should_not be_nil
      task.state.should eq(Task::STATES[:failed])
    end
  end
  
  describe "finish! method" do
    let(:task) { tasks(:task_1) }
    
    before(:each) do
      task.finished_at.should be_blank
      task.state.should_not eq(Task::STATES[:finished])
    end
    
    it "should finished task and assigned finished at time" do
      task.finish!
      task.finished_at.should_not be_blank
      task.state.should eq(Task::STATES[:finished])
    end
    
    
  end
  
  describe "run" do
    pending
  end

  describe "task2xml" do
    pending
  end
end
