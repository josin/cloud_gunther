require File.dirname(__FILE__) + "/../../config/application"
require File.dirname(__FILE__) + "/../../lib/daemons/abstract_daemon"
require 'daemons'
require 'logger'
require 'amqp'


module Daemons
  class OutputsWorker < Daemons::AbstractDaemon
    OUTPUTS_QUEUE = "outputs"
    
    def run
      init_rails_context
      
      logger :info, "Starting outputs worker daemon."
      
      AMQP.start(AppConfig.amqp_config) do |connection|
        channel = AMQP::Channel.new(connection)
        outputs_queue = channel.queue(OUTPUTS_QUEUE)
        
        Signal.trap("INT") do
          connection.close do
            EM.stop { exit }
          end
        end
        
        logger :info, "Subscribing to #{OUTPUTS_QUEUE}..."
        
        outputs_queue.subscribe do |msg|
          logger :info, "task output: #{msg}"
          
          begin
            output_hash = Hash.from_xml(msg)
            obj = Output.create(output_hash["output"])
            logger :info, "Created output with id: #{obj.id}"
          rescue Exception => e
            # e.backtrace
            logger :error, e.message
          end
        end
      end
    end # of run
  end # of class
end # of module
