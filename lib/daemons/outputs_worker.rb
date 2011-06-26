module Daemons
  class OutputsWorker
    class << self
      def run
        amqp_config = AmqpConfig.config
        bunny = Bunny.new(amqp_config)
        bunny.start
        
        queue = bunny.queue("outputs")
        
        while msg = queue.pop[:payload]
          break if msg == :queue_empty

          Rails.logger.info "task output: #{msg}"
          output_hash = Hash.from_xml(msg)
          obj = Output.create(output_hash["output"])
          Rails.logger.info "Created output with id: #{obj.id}"
        end
      end # of run
    end
  end # of class
end # of module

#!/usr/bin/env ruby

# You might want to change this
# ENV["RAILS_ENV"] ||= "production"

# require File.dirname(__FILE__) + "/../../config/application"
# Rails.application.require_environment!
# 
# $running = true
# Signal.trap("TERM") do 
#   $running = false
#   AMQP.stop { EM.stop }
# end
# 
# if ($running)
#   amqp_config = AmqpConfig.config
# 
#   AMQP.start(amqp_config) do
#     amq = MQ.new
#     queue = amq.queue("outputs")
# 
#     queue.subscribe(:ack => true) do |header, output|
#       Rails.logger.info "task output: #{output}"
#       output_hash = Hash.from_xml(output)
#       obj = Output.create(output_hash["output"])
#       Rails.logger.info "Created output with id: #{obj.id}"
#       header.ack
#     end
#   end
# end