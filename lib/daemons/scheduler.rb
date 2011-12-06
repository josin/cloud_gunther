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
        EventMachine.add_timer(AppConfig.config[:scheduler_interval]) { reschedule_tasks }
      end
    rescue SignalException => e
      logger :info, "Stopping..."
      return 0
    end
    
    def reschedule_tasks
      logger :info, "Rescheduling tasks...."
      # EventMachine.add_timer(AppConfig.config[:scheduler_interval]) { reschedule_tasks }
      
      # fetch task with highest priority
      task = Task.where(:state => "ready", )
      
      
      
      
    end
    
  end
end
