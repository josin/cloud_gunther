# rails runner ./lib/outputs.rb
# Script for handling outputs queue.

# TODO: add logger, encapsulate into a class for better testing
# TODO: research how to run this task automaticaly after deployment and automatic restarts...

require "bunny"
require "amqp"
require "rexml/document"

# <?xml version="1.0" encoding="UTF-8"?>
# <output task_id="">
#   <task_params instance_id="" />
#   <task_output>...</task_output>
# </output>
def parse_output_xml(msg_str)
  opts = {}
  output_xml = REXML::Document.new msg_str
  
  output_xml.elements.each("output") do |element|
    opts[:task_id] = element.attributes["task_id"]
  end

  output_xml.elements.each("output/task_params") do |element|
    opts[:instance_id] = element.attributes["instance_id"]
  end

  output_xml.elements.each("output/task_output") do |element|
    opts[:task_output] = element.text
  end
  
  opts
end

def create_output(opts)
  ::Output.create :task_id => opts[:task_id],
                :stdout => opts[:task_output],
                :params => { :instance_id => opts[:instance_id] }
end

AMQP.start({:host => "localhost", :user => "guest", :pass => "guest", :vhost => "/"}) do
  amq = MQ.new
  queue = amq.queue("outputs")
  
  queue.subscribe(:ack => true) do |header, output|
    puts "task output: #{output}"
    create_output(parse_output_xml(output))
    header.ack
  end
end

# amqp_config = Qusion::AmqpConfig.new.config_opts
# b = Bunny.new(amqp_config)
# b.start
# q = b.queue("outputs")
# 
# msg = q.pop[:payload]
# puts "task output: #{msg} "



