#!/usr/bin/env ruby

INPUT_QUEUE = "inputs"
OUTPUT_QUEUE = "outputs"

require "bunny"
require "rexml/document"
require "logger"

module AlgRunner
  class Runner
    include REXML
  
    attr_reader :task_id, :task_opts
    attr_accessor :logger, :input_queue, :output_queue
  
    def initialize(args)
      Bunny.run { |c| @input_queue = c.queue(args[:input_queue]) }
      Bunny.run { |c| @output_queue = c.queue(args[:output_queue]) }
      @logger ||= Logger.new(STDOUT)
    end
  
    def start!
      while msg = @input_queue.pop
        @task_opts = parse_input(msg)
      
        download_binary(@task_opts[:filename], @task_opts[:alg_binary_url])
        task_output = launch_algorithm(@task_opts[:launch_cmd])

        break # FIXME: only for debug
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
      end

      task_xml.elements.each("task/launch_cmd") do |element|
        opts[:launch_cmd] = element.attributes["cmd"]
      end
    
      opts
    end
  
    def send_output
    end
  
    def download_binary(filename, binary_url)
      f = IO.popen("curl -o #{filename} #{binary_url}")
      f.close
      true
    end
  
    def launch_algorithm(launch_cmd)
      f = IO.popen("#{launch_cmd}")
      task_output = f.readlines
      logger.debug { task_output }
      f.close

      task_output
    end
  end
end

unless defined?(Rails)
  runner = AlgRunner::Runner.new(:input_queue => INPUT_QUEUE, :output_queue => OUTPUT_QUEUE)
  runner.start!
end

