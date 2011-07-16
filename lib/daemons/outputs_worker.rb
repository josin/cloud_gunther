require "logger"

module Daemons
  class OutputsWorker
    class << self
      def run
        logger = Logger.new(STDOUT)
        amqp_config = AppConfig.amqp_config
        bunny = Bunny.new(amqp_config)
        bunny.start
        
        queue = bunny.queue("outputs")
        
        while msg = queue.pop[:payload]
          break if msg == :queue_empty

          logger.info "task output: #{msg}"
          output_hash = Hash.from_xml(msg)
          obj = Output.create(output_hash["output"])
          logger.info "Created output with id: #{obj.id}"
        end
      end # of run
    end
  end # of class
end # of module
