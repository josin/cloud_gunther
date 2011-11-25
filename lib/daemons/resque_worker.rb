require File.dirname(__FILE__) + "/../../config/application"
require File.dirname(__FILE__) + "/../../lib/daemons/abstract_daemon"
require 'daemons'
require 'logger'

module Daemons
  class ResqueWorker < Daemons::AbstractDaemon
    
    def run
      init_rails_context
      
      logger :info, "Starting resque worker..."
      
      @worker = Resque::Worker.new('*') # Specify which queues this worker will process
      @worker.verbose = 1 # Logging - can also set vverbose for 'very verbose'
      @worker.work
    end
    
    def stop
      logger :info, "Shuting down resque worker..."
      @worker.try(:shutdown)
    end
    
  end
end

