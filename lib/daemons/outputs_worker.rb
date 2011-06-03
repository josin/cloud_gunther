#!/usr/bin/env ruby

# You might want to change this
# ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/application"
Rails.application.require_environment!

$running = true
Signal.trap("TERM") do 
  $running = false
  AMQP.stop
end

if ($running)
  amqp_config = AmqpConfig.config

  AMQP.start(amqp_config) do
    amq = MQ.new
    queue = amq.queue("outputs")

    queue.subscribe(:ack => true) do |header, output|
      Rails.logger.info "task output: #{output}"
      output_hash = Hash.from_xml(output)
      obj = Output.create(output_hash["output"])
      Rails.logger.info "Created output with id: #{obj.id}"
      header.ack
    end
  end
end