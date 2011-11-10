#!/usr/bin/env ruby

require File.dirname(__FILE__) + "/../../config/application"
require File.dirname(__FILE__) + "/../../lib/daemons/abstract_daemon"
require 'daemons'
require 'logger'
require 'amqp'

module Daemons
  class InstanceServiceCtl < Daemons::AbstractDaemon
    INSTANCE_SERVICE_QUEUE = "instance_service"

    def run
      init_rails_context
      
      logger.info "Starting instance_service listener."
      
      AMQP.start(AppConfig.amqp_config) do |connection|
        channel = AMQP::Channel.new(connection)
        instance_service_queue = channel.queue(INSTANCE_SERVICE_QUEUE)
        
        Signal.trap("INT") do
          connection.close do
            EM.stop { exit }
          end
        end
        
        logger.info "Subscribing to instance_service queue."
        
        instance_service_queue.subscribe do |msg|
          logger.info "Request for terminating instance: #{msg}"

          begin
            # terminate instances
            connection = CloudEngine.where(:engine_type => CloudEngine::ENGINE_TYPES[:eucalyptus]).first.connect!
            connection.terminate_instances([msg])
          rescue Exception => e
            # e.backtrace
            logger.error e.message
          end
        end
      end
    end
  end # of InstanceService class
end # of module

unless defined?(Rails)
  Daemons::InstanceServiceCtl.new.run! "instance_service"
end
