require "singleton"

class AppConfig
  include Singleton
  
  class << self
    
    def config
      @@config ||= YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env].symbolize_keys
    end
  
    def amqp_config
      @@amqp_config ||= YAML.load_file("#{Rails.root}/config/amqp.yml")[Rails.env].symbolize_keys
    end

  end # of class.self
  
end # of class
