# Class responsible for starting appropriate number of instances and setup them
# to proper state which is required for running algorithms.
#
# == Process workflow
# 1. start instances and wait until ready
# 2. setup instances using Image#start_up_script
# 3. inject runner script and let them work
# TODO: after starting instances, save theirs IDs into task for monitoring, stopping etc.
class InstancesController
  attr_reader :task, :options
  
  ENVIRONMENTS = [:cloud, :local]
  
  def initialize(task, *args)
    @task = task
    
    options = {
      :environment => :cloud,
      :task_options => {},
    }
    @options = options.merge(args.extract_options!)
  end

  def prepare_instances

  end

  private

  def run_instances
  end


  def start_instances

  end


end