require File.dirname(__FILE__) + "/../../config/application"
require File.dirname(__FILE__) + "/../../lib/daemons/abstract_daemon"
require 'daemons'
require 'eventmachine'
require 'logger'
require 'amqp'

module Daemons
  class Scheduler < Daemons::AbstractDaemon
    
    def run
      init_rails_context
      
      logger :info, "Starting scheduler..."
      
      EventMachine.run do
        logger :info, 'Starting scheduler timer...'
        EventMachine.add_periodic_timer(AppConfig.config[:finished_task_check_interval]) { check_finished_tasks }
        EventMachine.add_timer(AppConfig.config[:scheduler_interval]) { reschedule_tasks }
      end
    rescue SignalException => e
      logger :info, "Stopping..."
      return 0
    end
    
    def reschedule_tasks
      logger :info, "Rescheduling tasks...."
      
      # fetch task with highest priority
      @task = Task.where(:state => Task::STATES[:ready]).order(:priority.desc).first
      
      if @task
        logger :info, "Scheduling task##{@task.id}..."
        if @task.attempts >= AppConfig.config[:attempts_to_rerun_task].to_i
          @task.failure! "Maximum limit to reschedule task reached. (#{@task.attempts})"
        else
          # run the task
          if available_resources_for_task?(@task)
            @task.update_attributes({:state => Task::STATES[:running], :started_at => Time.now})
            Resque.enqueue(TaskRunner, @task.id) 
          else
            @task.update_attribute(:attempts, @task.attempts + 1)
          end
        end
      end
      
      # schedule next run of scheduler
      EventMachine.add_timer(AppConfig.config[:scheduler_interval]) { reschedule_tasks }
    end
    
    protected
    
    def available_resources_for_task?(task)
      # check if there is enough resources
      availability_zones_info = task.cloud_engine.fetch_availability_zones_info
      
      zone = availability_zones_info.select { |a| a[:zone_name] == task.zone_name }.first
      return false unless zone
      
      return false if !zone.has_key?(:resources) or !zone[:resources].has_key?(task.instance_type)
      instance_type = zone[:resources][task.instance_type]
      
      return instance_type[:free].to_i >= task.instances_count.to_i
    end
    
    def check_finished_tasks
      logger :info, "Checking finished tasks..."
      
      running_tasks = Task.running
      logger :info, "Found #{running_tasks.size} tasks..."
      
      running_tasks.each do |task|
        next if (Time.now.to_i - task.updated_at.to_i) < 60
        
        if task.instances.blank?
          # Task is running and has no instance after 1.minute? => failed
          logger :info, "Task##{task.id} failed."
          task.failure! "Internal cloud engine error - running task has no running instances..."
        else
          instances_info = task.fetch_instances_info
          
          # None of registered instances is running => finish
          # go through instances => if all of them are shutting-down or terminated => task.finish!
          if instances_info.blank? or !any_running_instance?(instances_info)
            logger :info, "Task##{task.id} finished."
            task.finish! 
          end
        end
      end
      
      logger :info, "Finished tasks check finished."
    end
    
    private
    def any_running_instance?(instances_info)
      running_instances = false
      instances_info.each do |instance|
        return nil unless instance[:aws_state].present?
        running_instances = true unless ["terminated", "shutting-down"].include?(instance[:aws_state])
      end
      running_instances
    end
    
  end
end
