#!/usr/bin/env ruby

require "bunny"
require "popen4"
require "rexml/document"
require "logger"
require "net/http"
require "uri"
require "yaml"
require "cgi"

INSTANCE_SERVICE_QUEUE = "instance_service"
USER_DATA_URL = "http://169.254.169.254/latest/user-data"
INSTANCE_ID_URL = "http://169.254.169.254/latest/meta-data/instance-id"

# TODO: begin raise blocks => doesn't matter what happen, script must send back message
module AlgRunner
  class Runner
    include REXML
  
    attr_accessor :logger, :bunny, :input_queue, :output_queue
  
    def initialize(bunny, input_queue, output_queue, logger = Logger.new(STDOUT))
      @bunny = bunny
      @input_queue = input_queue
      @output_queue = output_queue
      @logger = logger
    end
  
    def start!
      logger.info { "Starting AlgRunner." }
      
      # while msg = @input_queue.pop
      while msg = @input_queue.pop[:payload]
        break if msg == :queue_empty
        
        logger.info { "Received message: #{msg}" }
        
        @task_opts = parse_input(msg)
      
        if !@task_opts[:alg_binary_url].nil? && !@task_opts[:alg_binary_url].empty?
          download_binary(@task_opts[:filename], @task_opts[:alg_binary_url]) 
        end
        
        task_output = launch_algorithm(@task_opts[:launch_cmd])

        task_output_xml = create_output_xml(task_output, @task_opts)
        send_output(task_output_xml)
      end
      
      logger.info { "Queue is empty." }
      
      # queue is empty, instance is idle => request termination
      request_termination
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
      @bunny.exchange('').publish(task_output_xml, :key => @output_queue, :routing_key => @output_queue)
    end
  
    def download_binary(filename, binary_url)
      f = IO.popen("curl -o #{filename} #{binary_url}")
      f.close
    end
  
    def launch_algorithm(launch_cmd)
      begin
        launch_cmd = CGI::unescapeHTML(launch_cmd)
        # logger.debug { launch_cmd }
        stdout, stderr = "", ""
        status = POpen4::popen4(launch_cmd) do |out, err, stdin, pid|
          out.each_line { |line| stdout << line }
          err.each_line { |line| stderr << line }
        end
        
        logger.info { "Algorithms launch outputs:" }
        logger.info { "stdout: #{stdout}" }
        logger.info { "stderr: #{stderr}" }
        
        unless status.nil?
          stdout << "Program finished with status: #{status.exitstatus} at #{Time.now}"
        else # command failed
          stdout << "Program finished at #{Time.now}"
          stderr << "Command '#{launch_cmd}' failed to run."
        end
        
        return { :stdout => stdout, :stderr => stderr }
      rescue Exception => e
        return { :stdout => "", :stderr => e.message }
      end
    end
    
    # TODO: send_idle with instance_id
    # instance_id => http://169.254.169.254/latest/meta-data/instance-id
    def request_termination
      instance_id = AlgRunner.fetch_url(INSTANCE_ID_URL)

      logger.info { "Requesting terminating for #{instance_id}" }
      @bunny.queue INSTANCE_SERVICE_QUEUE
      @bunny.exchange('').publish(
        { :instance_id => instance_id.to_s, :action => :termination }.to_yaml, 
        :key => INSTANCE_SERVICE_QUEUE, :routing_key => INSTANCE_SERVICE_QUEUE
      )
    end
  end # of class
  
  # load configs about MQ broker from instance meta-data loopback
  def self.get_user_data
    user_data = fetch_url(USER_DATA_URL)
    YAML::load(user_data)
  end
  
  def self.init_amqp(instance_meta_data)
    input_queue = instance_meta_data[:input_queue]
    output_queue = instance_meta_data[:output_queue]
    config = instance_meta_data[:amqp_config]
  
    bunny = Bunny.new(config)
    bunny.start # TODO: check if :connected otherwise ... what?
    input_queue = bunny.queue(input_queue)
    # output_queue = bunny.queue(output_queue)
    bunny.queue(output_queue)
    
    [bunny, input_queue, output_queue]
  end
  
  def self.fetch_url(url)
    IO.popen("curl -s #{url}") { |f| f.readlines }.join
  end
end # of module

unless defined?(Rails) # in this case it's running as a standalone script
  instance_meta_data = AlgRunner.get_user_data
  amqp_conn = AlgRunner.init_amqp(instance_meta_data)
  
  runner = AlgRunner::Runner.new(amqp_conn[0], amqp_conn[1], amqp_conn[2]) # bunny, input_queue, output_queue
  runner.start!
end

