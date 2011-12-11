require File.dirname(__FILE__) + "/../../config/application"
require File.dirname(__FILE__) + "/../../lib/daemons/abstract_daemon"
require 'daemons'
require 'logger'
require 'amqp'

module Daemons
  class InstanceService < Daemons::AbstractDaemon
    INSTANCE_SERVICE_QUEUE = "instance_service"

    def run
      init_rails_context
      
      logger :info, "Starting instance_service listener."
      
      AMQP.start(AppConfig.amqp_config) do |connection|
        channel = AMQP::Channel.new(connection)
        instance_service_queue = channel.queue(INSTANCE_SERVICE_QUEUE)
        
        Signal.trap("INT") do
          connection.close do
            EM.stop { exit }
          end
        end
        
        logger :info, "Subscribing to instance_service queue."
        instance_service_queue.subscribe { |msg| instance_termination(msg) }
      end
    end
  
    protected
    
    def instance_termination(msg)
      logger :info, "Request for terminating instance: #{msg}"
      
      msg_hash = YAML::load(msg)

      # terminate instances
      connection = CloudEngine.where(:engine_type => CloudEngine::ENGINE_TYPES[:eucalyptus]).first.connect!
      connection.terminate_instances([msg_hash[:instance_id]])
    rescue Exception => e
      logger :error, "#{e.message}\n#{e.backtrace.join('\n')}"
    end
  end # of InstanceService class
end # of module

