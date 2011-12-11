require 'spec_helper'

describe Daemons::Scheduler do
  fixtures :tasks
  
  let(:scheduler) { Daemons::Scheduler.new }
  let(:cloud_engine) { mock_model(CloudEngine).as_null_object }
  let(:task) { tasks(:task_1) }
  
  before(:each) do
    task.cloud_engine = cloud_engine
    task.task_params = { "instances_count" => "2", "instance_type" => "m1.small", "zone_name" => "stud2" }
  end
  
  describe "run method" do
    # include EventedSpec::SpecHelper

    it "should add timer for scheduler and periodic timer for finished tasks" do
      scheduler.should_receive :init_rails_context
      EventMachine.should_receive :run
      scheduler.run
    end
  end
  
  describe "reschedule_tasks method" do
    before(:each) do
      EventMachine.should_receive(:add_timer)
    end
    
    it "postpone scheduling if no task available" do
      Task.stub_chain(:where, :order, :first).and_return(nil)
      scheduler.reschedule_tasks
    end
    
    it "postpone scheduling if task is available but not enough resources available" do
      Task.stub_chain(:where, :order, :first).and_return(task)
      scheduler.stub(:available_resources_for_task?).and_return(false)
      Resque.should_not_receive(:enqueue)
      expect { scheduler.reschedule_tasks }.to change{task.attempts}.from(0).to(1)
    end
    
    it "fail to reschedule tasks if too much attempts" do
      Task.stub_chain(:where, :order, :first).and_return(task)
      scheduler.stub(:available_resources_for_task?).and_return(true)
      task.stub(:attempts => 100)
      Resque.should_not_receive(:enqueue)

      expect { scheduler.reschedule_tasks }.to change{task.state}.to(Task::STATES[:failed])
    end

    it "reschedule task if available resources available" do
      Task.stub_chain(:where, :order, :first).and_return(task)
      scheduler.stub(:available_resources_for_task?).and_return(true)
      Resque.should_receive(:enqueue).with(TaskRunner, task.id)
      scheduler.reschedule_tasks
    end
  end
  
  describe "available_resources_for_task? method" do
    it "is true when enough resources available" do
      cloud_engine.stub(:fetch_availability_zones_info => [{
        :zone_name => "stud2", 
        :zone_state => "147.32.84.118",
        :resources => { "m1.small" => {:free => "0003", :max => "0000", :cpu => 1, :ram => 320, :disk => 4} }
      }])
          
      scheduler.send(:available_resources_for_task?, task).should be_true
    end
    
    it "is false when not enough resources available" do
      cloud_engine.stub(:fetch_availability_zones_info => [{
        :zone_name => "stud2", 
        :zone_state => "147.32.84.118",
        :resources => { "m1.small" => {:free => "0001", :max => "0000", :cpu => 1, :ram => 320, :disk => 4} }
      }])
          
      scheduler.send(:available_resources_for_task?, task).should be_false
    end

    it "is false when task's zone is not present" do
      cloud_engine.stub(:fetch_availability_zones_info => [])
      scheduler.send(:available_resources_for_task?, task).should be_false
    end

    it "is false when task's zone with given name is not present" do
      cloud_engine.stub(:fetch_availability_zones_info => [{
        :zone_name => "new-zone", 
        :zone_state => "147.32.84.118",
        :resources => { "m1.small" => {:free => "0001", :max => "0000", :cpu => 1, :ram => 320, :disk => 4} }
      }])
      
      scheduler.send(:available_resources_for_task?, task).should be_false
    end
    
    it "is false when zone doesn't have resources" do
      cloud_engine.stub(:fetch_availability_zones_info => [{
        :zone_name => "stud2", 
        :zone_state => "147.32.84.118",
        :resources => {  }
      }])
      scheduler.send(:available_resources_for_task?, task).should be_false
    end
    
    it "is false when zone resources doesn't have specified instance type" do
      cloud_engine.stub(:fetch_availability_zones_info => [{
        :zone_name => "stud2", 
        :zone_state => "147.32.84.118",
        :resources => { "m1.medium" => {:free => "0001", :max => "0000", :cpu => 1, :ram => 320, :disk => 4} }
      }])
      scheduler.send(:available_resources_for_task?, task).should be_false
    end
  end
  
  describe "any_running_instances? method" do
    let(:instances_info) { [{aws_state:"terminated"},{aws_state:"shutting-down"}] }

    it "returns false if all instances are in state shutting-down or terminated" do
      scheduler.send(:any_running_instance?, instances_info).should be_false
    end
    
    it "returns true if at least one of instances isn't in state stutting-down or terminated" do
      instances_info << {aws_state:"running"}
      scheduler.send(:any_running_instance?, instances_info).should be_true
    end
    
    it "returns nil when key :aws_state is not present" do
      scheduler.send(:any_running_instance?, [{state:"running"}]).should be_nil
    end
  end
  
end