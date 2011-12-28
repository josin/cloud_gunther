require 'spec_helper'

describe TaskRunner do
  let(:task) { mock_model(Task).as_null_object }
  
  describe "self.perform method" do
    it "should run the task" do
      Task.should_receive(:find).with(task.id).and_return(task)
      task.should_receive(:run)
      TaskRunner.perform(task.id)
    end
  end
end