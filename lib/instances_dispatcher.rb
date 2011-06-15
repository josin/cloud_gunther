require "net/ssh"
require "net/scp"

# Class responsible for starting appropriate number of instances and setup them
# to proper state which is required for running algorithms.
#
# == Process workflow
# 1. start instances and wait until ready
# 2. setup instances using Image#start_up_script
# 3. inject runner script and let them work
# TODO: after starting instances, save theirs IDs into task for monitoring, stopping etc.
class InstancesDispatcher
  
  ENVIRONMENTS = [:cloud, :local]
  SCRIPT_NAME = "runner.rb"
  SCRIPT_PATH = File.join(Rails.root, "lib", "alg_runner")
  
  TIMEOUT_LIMIT = 512 # sec
  WAIT_STEP = 20 # sec
  
  attr_reader :task
  attr_accessor :instances, :connection
  
  def initialize(task, *args)
    @task = task
    @instances = []
    
    # options = {
    #   :environment => :cloud,
    #   :task_options => {},
    # }
    # @options = options.merge(args.extract_options!)
  end
  
  def run_instances
    launch_instances
    wait_until_instances_ready
    prepare_instances
    run_task
  end

  private

  # README: https://github.com/rightscale/right_aws/blob/master/lib/ec2/right_ec2_instances.rb
  # ec2_launch_instances
  # instance-user-data => information for connection to amqp broker
  # userdata: curl http://169.254.169.254/latest/meta-data/ => string with given metadata
  # Required user-data:key => "value", 
  # => amqp = {host, port, user, pass, vhost, timeout}
  # => inputs queue, outputs queue
  def launch_instances
    @connection = @task.cloud_engine.connect!

    image_opts = @task.image.launch_params
    image_id = image_opts.delete(:image_id)
    key_pair = image_opts.delete(:key_pair) # TODO: move to image or cloud engine config
    
    instances_count = @task.task_params[:instances_count]
    
    @instances = @connection.launch_instances(image_id, {
      :min_count => instances_count || 1,
      :addressing_type => "private", # MUST HAVE
      :key_name => key_pair || "cvut-euca", # MUST HAVE
      :user_data => create_user_data, # MUST HAVE
      :group_ids => "task-#{@task.id}",
    })
    logger.debug @instances
    
    # TODO: save instances ids into task
  end
  
  # waits until instances ready and instances are ready to connect
  # wait in google style - 1, 2, 4, 8, ... , 512 otherwise Task#state=failed
  def wait_until_instances_ready
    wait_time = 0
    
    until instances_ready? do
      logger.info "Waiting #{WAIT_STEP} sec until instances is ready."
      sleep WAIT_STEP
      wait_time += WAIT_STEP
      
      raise "Instances connection timeout." if wait_time > TIMEOUT_LIMIT
    end

    logger.info "Instances #{@instances.collect{ |i| i[:aws_instance_id] }} are running."
    logger.info "Instances are ready to connect."
  end
  
  # if state is "running" returns true otherwise false
  def instances_ready?
    running_instances = @connection.describe_instances(@instances.collect{ |i| i[:aws_instance_id] })
    
    running_flag = true
    running_instances.each { |instance| running_flag = false if instance[:aws_state] != "running" }
    
    @instances = running_instances if running_flag
    
    return running_flag
  end
  
  # run init scripts, inject ruby runner
  def prepare_instances
    @instances.each do |instance|
      ssh_host = instance[:dns_name]
      
      logger.info "Connecting and preparing instance #{instance[:aws_instance_id]} with dns_name: #{ssh_host}"
      
      ssh_session = Net::SSH.start(ssh_host, "root")
      
      # run init scripts
      start_up_script = @task.image.start_up_script_for_ssh(@task)
      logger.debug { start_up_script }
      ssh_session.exec! start_up_script
      
      # inject ruby runner
      ssh_session.scp.upload! "#{SCRIPT_PATH}/#{SCRIPT_NAME}", "#{SCRIPT_NAME}" do |ch, name, sent, total|
        puts "#{name}: #{sent}/#{total}"
      end
      
      ssh_session.close
    end
  end

  # Run script on remote side
  def run_task
    @instances.each do |instance|
      ssh_host = instance[:dns_name]
      ssh_session = Net::SSH.start(ssh_host, "root")
      
      logger.info "Connecting and running task on instance #{instance[:aws_instance_id]} with dns_name: #{ssh_host}"
      ssh_session.exec! "/bin/bash -l -c 'nohup ruby #{SCRIPT_NAME} > out.log 2>&1 &'"

      ssh_session.close
    end
  end
  
  def create_user_data
    {
      :amqp_config => AmqpConfig.config,
      :input_queue => "inputs",
      :output_queue => "outputs",
    }.to_yaml
  end
  
  def logger
    Rails.logger
  end

end