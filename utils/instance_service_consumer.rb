#!/usr/bin/env ruby

require "bunny"

INSTANCE_SERVICE_QUEUE = "instance_service"

bunny = Bunny.new
puts bunny.start

queue = bunny.queue INSTANCE_SERVICE_QUEUE

while msg = queue.pop[:payload]
  break if msg == :queue_empty
  
  puts "Received: '#{msg}'"
end

puts "Queue is empty."
