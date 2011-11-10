require 'daemons'
require 'logger'

module Daemons
  class AbstractDaemon
    def run!(app_name = "cloud_gunther")
      @app_name = app_name
      Daemons.run_proc "#{@app_name}_daemon", :monitor => true, &method(:run)
    end
    
    def run
      raise "Not implemented yet."
    end
    
    def init_rails_context
      # Init Rails
      Rails.application.require_environment!
      Rails.logger = ActiveSupport::BufferedLogger.new("#{Rails.root}/log/#{@app_name}.log")
      Rails.logger.level = ActiveSupport::BufferedLogger::DEBUG
      ActiveRecord::Base.logger = Rails.logger
      Rails.logger.auto_flushing = true
    end
    
    def logger
      Rails.logger
    end
  end
end

