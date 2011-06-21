#!/usr/bin/env ruby

# You might want to change this
# ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/application"
Rails.application.require_environment!

$running = true
Signal.trap("TERM") do 
  $running = false
  AMQP.stop { EM.stop }
end

if ($running)
  amqp_config = AmqpConfig.config

  AMQP.start(amqp_config) do
    amq = MQ.new
    queue = amq.queue("instance_service")

    queue.subscribe(:ack => true) do |header, instance|
      Rails.logger.info "Request for terminating instance: #{instance}"

      # terminate instances
      connection = CloudEngine.where(:engine_type => CloudEngine::ENGINE_TYPES[:eucalyptus]).first
      connection.terminate_instances([instance])
      
      header.ack
    end
  end
end

