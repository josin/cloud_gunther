require "singleton"

class AmqpConfig
  include Singleton

  def self.config
    @@config ||= YAML.load_file("#{Rails.root}/config/amqp.yml")[Rails.env].symbolize_keys
  end
end