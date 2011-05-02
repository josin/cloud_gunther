#!/usr/bin/env ruby

require "bunny"
require "popen4"
require "rexml/document"
require "logger"

# TODO: begin raise blocks => doesn't matter what happen, script must send back message
module AlgRunner
  class Runner
    include REXML
  
    attr_accessor :logger, :input_queue, :output_queue
  
    def initialize(input_queue, output_queue)
      @input_queue = input_queue
      @output_queue = output_queue
      
      @logger ||= Logger.new(STDOUT)
    end
  
    def start!
      # while msg = @input_queue.pop
      while msg = @input_queue.pop[:payload]
        break if msg == :queue_empty
        
        task_opts = parse_input(msg)
      
        download_binary(task_opts[:filename], task_opts[:alg_binary_url]) unless task_opts[:alg_binary_url].nil?
        task_output = launch_algorithm(task_opts[:launch_cmd])

        task_output_xml = create_output_xml(task_output, task_opts)
        send_output(task_output_xml)
        
        # FIXME: only for d&d
      end
    end
  
    private
    def parse_input(msg_str)
      task_xml = Document.new msg_str

      opts = {}
    
      task_xml.elements.each("task") do |element|
        opts[:task_id] = element.attributes["id"]
      end

      task_xml.elements.each("task/task_params") do |element|
        opts[:instance_id] = element.attributes["instance_id"]
      end

      task_xml.elements.each("task/alg_binary") do |element|
        opts[:alg_binary_url] =  element.attributes["url"]
        opts[:filename] =  element.attributes["filename"]
        opts[:launch_cmd] = element.attributes["launch_cmd"]
      end
    
      opts
    end
    
    # <?xml version="1.0" encoding="UTF-8"?>
    # <output>
    #   <task-id></task-id>
    #   <stdout></stdout>
    #   <stderr></stderr>
    #   <params>
    #     <instance-id></instance-id>
    #   </params>
    # </output>
    def create_output_xml(task_output, options)
      output_xml = Document.new
      output_xml.add(XMLDecl.new("1.0", "UTF-8"))
      
      root = output_xml.add_element("output")
      root.add_element("task-id").add_text(options[:task_id].to_s)
      
      params = Element.new("params")
      params.add_element("instance-id").add_text(options[:instance_id].to_s)
      root.add_element(params)
      
      root.add_element("stdout").add_text(task_output[:stdout].to_s)
      root.add_element("stderr").add_text(task_output[:stderr].to_s)
      
      output_xml.to_s
    end
  
    def send_output(task_output_xml)
      @output_queue.publish(task_output_xml)
    end
  
    def download_binary(filename, binary_url)
      f = IO.popen("curl -o #{filename} #{binary_url}")
      f.close
    end
  
    def launch_algorithm(launch_cmd)
      begin
        logger.debug { launch_cmd }
        stdout, stderr = "", ""
        status = POpen4::popen4(launch_cmd) do |out, err, stdin, pid|

          out.each_line { |line| stdout << line }
          err.each_line { |line| stderr << line }
        end
        
        stdout << "Program finished with status: #{status.exitstatus} at #{Time.now}"
        
        return { :stdout => stdout, :stderr => stderr }
      rescue Exception => e
        return e.message
      end
    end
  end
end

unless defined?(Rails) # in this case it's running as a standalone script
  INPUT_QUEUE = "inputs"
  OUTPUT_QUEUE = "outputs"
  CONFIG = {:host => "rabbitmq", :user => "guest", :pass => "guest", :vhost => "/"}
  
  bunny = Bunny.new(CONFIG)
  bunny.start
  input_queue = bunny.queue(INPUT_QUEUE)
  output_queue = bunny.queue(OUTPUT_QUEUE)
  
  runner = AlgRunner::Runner.new(input_queue, output_queue)
  runner.start!
end

