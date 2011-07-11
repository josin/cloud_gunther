#!/usr/bin/env ruby

%w{rubygems sinatra yaml}.each { |lib| require lib }

# set :bind, "169.254.169.254"
# set :port, 80

get '/' do
  "Instance user-data simulator."
end

# User data => http://169.254.169.254/latest/user-data/
get '/latest/user-data' do
  {
    :amqp_config => {
      :host => "localhost", 
      :port => 5672, 
      :user => "josin", 
      :pass => "josin", 
      :vhost => "/", 
      :timeout => 3600, 
      :logging => false, 
      :ssl => false },
    :input_queue => "inputs",
    :output_queue => "outputs",
  }.to_yaml
end


# Instance id => http://169.254.169.254/latest/meta-data/instance-id
get '/latest/meta-data/instance-id' do
  "i-123456"
end


