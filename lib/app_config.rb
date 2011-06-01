require "singleton"

class AppConfig
  include Singleton
  
  def self.config
    @@config ||= YAML.load_file("#{Rails.root}/config/application.yml")[Rails.env].symbolize_keys
  end
end
