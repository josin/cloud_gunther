# rails runner ./lib/outputs_job.rb
# Script for handling outputs queue.

# TODO: replace puts with proper logger
# TODO: research how to run this task automaticaly after deployment and automatic restarts...
# TODO: should be rewrite in class or module for ability to test it

require "amqp"

amqp_config = Qusion::AmqpConfig.new.config_opts

AMQP.start(amqp_config) do
  amq = MQ.new
  queue = amq.queue("outputs")
  
  queue.subscribe(:ack => true) do |header, output|
    # puts "task output: #{output}"
    output_hash = Hash.from_xml(output)
    obj = Output.create(output_hash["output"])
    puts "Created output with id: #{obj.id}"
    header.ack
  end
end

# require "bunny"
# b = Bunny.new(amqp_config)
# b.start
# q = b.queue("outputs")
# 
# msg = q.pop[:payload]
# puts "task output: #{msg} "



