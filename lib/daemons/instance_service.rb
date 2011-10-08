require "logger"

module Daemons
  class InstanceService
    class << self
      def run
        logger = Logger.new(STDOUT)
        amqp_config = AppConfig.amqp_config
        bunny = Bunny.new(amqp_config)
        bunny.start
        
        logger.info("Connected to MQ Broker.")
        
        queue = bunny.queue("instance_service")
        
        while msg = queue.pop[:payload]
          break if msg == :queue_empty
          
          logger.info "Request for terminating instance: #{msg}"
    
          # terminate instances
          connection = CloudEngine.where(:engine_type => CloudEngine::ENGINE_TYPES[:eucalyptus]).first.connect!
          connection.terminate_instances([msg])
        end
        
        bunny.stop
      end # of run
    end
  end # of class
end # of module
