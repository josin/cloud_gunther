require 'daemons'
require 'logger'

module Daemons
  class AbstractDaemon
    # TODO: how to set path for pid file to tmp/pids/ and then kill daemons from there?
    def run!(app_name = "cloud_gunther")
      @app_name = app_name
      Daemons.run_proc "#{@app_name}_daemon", 
        {
          :monitor => true,
          :singleton => true,
          :dir_mode => :normal,
          :dir => "/tmp",
        }, &method(:run)
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
    
    
    def logger(level, msg)
      Rails.logger.send level,  "#{Time.now} #{level} #{msg.to_s}"
    end
  end
end

