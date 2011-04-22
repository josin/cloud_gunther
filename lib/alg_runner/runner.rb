#!/usr/bin/env ruby

require "bunny"
require "rexml/document"
require "logger"

# TODO: begin raise blocks => doesn't matter what happen, script must send back message
module AlgRunner
  class Runner
    include REXML
  
    attr_reader :task_opts
    attr_accessor :logger, :input_queue, :output_queue
  
    def initialize(args)
      bunny = Bunny.new(args[:config])
      bunny.start
      @input_queue = bunny.queue(args[:input_queue])
      @output_queue = bunny.queue(args[:output_queue])
      
      @logger ||= Logger.new(STDOUT)
    end
  
    def start!
      # while msg = @input_queue.pop
      while msg = @input_queue.pop[:payload]
        break if msg == :queue_empty
        
        @task_opts = parse_input(msg)
      
        download_binary(@task_opts[:filename], @task_opts[:alg_binary_url]) unless @task_opts[:alg_binary_url].nil?
        task_output = launch_algorithm(@task_opts[:launch_cmd])

        task_output_xml = create_output_xml(task_output)
        send_output(task_output_xml)
        
        # break # FIXME: only for d&d
      end
    end
  
    private
    def parse_input(msg_str)
      task_xml = Document.new msg_str

      opts = {}
    
      task_xml.elements.each("task") do |element|
        opts[:task_id] = element.attributes["id"]
      end

      task_xml.elements.each("task/alg_binary") do |element|
        opts[:alg_binary_url] =  element.attributes["url"]
        opts[:filename] =  element.attributes["filename"]
        opts[:launch_cmd] = element.attributes["launch_cmd"]
      end
    
      opts
    end
    
    # <?xml version="1.0" encoding="UTF-8"?>
    # <output task_id="">
    #   <task_params instance_id="" />
    #   <task_output>...</task_output>
    # </output_task>
    def create_output_xml(task_output)
      output_xml = Document.new
      output_xml.add(XMLDecl.new("1.0", "UTF-8"))
      
      root = output_xml.add_element("output", {"task_id" => @task_opts[:task_id]})

      root.add_element("task_params", {"instance_id" => @task_opts[:instance_id]})

      output_elem = Element.new("task_output")
      task_output_str = ""
      task_output.each { |i| task_output_str << i }
      output_elem.add_text(task_output_str)
      root.add(output_elem)
      
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
        f = IO.popen("#{launch_cmd}")
        task_output = f.readlines
        logger.debug { task_output }
        f.close
        return task_output
      rescue Exception => e
        return e.message
      end
    end
  end
end

unless defined?(Rails) # in this case it's running as a standalone script
  INPUT_QUEUE = "inputs"
  OUTPUT_QUEUE = "outputs"
  CONFIG = {:host => "localhost", :user => "guest", :pass => "guest", :vhost => "/"}
  
  runner = AlgRunner::Runner.new(:config => CONFIG, :input_queue => INPUT_QUEUE, :output_queue => OUTPUT_QUEUE)
  runner.start!
end

