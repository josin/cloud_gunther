#!/usr/bin/env ruby

%w{rubygems sinatra yaml}.each { |lib| require lib }

# set :bind, "169.254.169.254"
# set :port, 80
set :environment, :development

get '/' do
  "Instance user-data simulator."
end

def user_data 
  {
    :amqp_config => {
      :host => "localhost", 
      :port => 5672, 
      :user => "guest", 
      :pass => "guest", 
      :vhost => "/", 
      :timeout => 3600, 
      :logging => false, 
      :ssl => false },
    :input_queue => "inputs",
    :output_queue => "outputs",
  }.to_yaml
end

def instance_id 
  "i-123456"
end

# User data => http://169.254.169.254/latest/user-data/
get '/latest/user-data' do; user_data; end
get '/latest/user-data/' do; user_data; end

# Instance id => http://169.254.169.254/latest/meta-data/instance-id
get '/latest/meta-data/instance-id' do; instance_id; end
get '/latest/meta-data/instance-id/' do; instance_id; end

