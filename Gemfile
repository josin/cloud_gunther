source 'http://rubygems.org'

gem 'rails', '3.0.9'

gem 'mysql2', '0.2.7'

gem 'devise'
gem "cancan", "1.6.5" # "~> 1.6.7"

gem 'paperclip'
gem 'will_paginate', ">=3.0"
gem 'simple-navigation'

gem 'meta_where'
gem 'meta_search'

gem 'amqp'
gem 'bunny'

gem 'right_aws', :git => "git://github.com/josin/right_aws.git"

gem 'net-ssh'
gem 'net-scp'
gem 'popen4'

gem 'resque', :require => 'resque/server' 
gem 'daemons'

gem 'awesome_print', :require => 'ap'

group :development do
  # debugger
  gem 'ruby-debug19', :platforms => :ruby_19
  gem 'ruby-debug', :platforms => :ruby_18
end

group :development, :test do
  gem 'rspec-rails', '2.6.0'
  gem 'spork', '~> 0.9.0.rc8'

  # gem 'cover_me', '~> 1.1.0'
  gem 'jasmine'
  gem 'cucumber-rails'
  gem "escape_utils" # FIXME: to avoid 'warning: regexp match /.../n against to UTF-8 string'
  gem 'database_cleaner'
  
  # Autotest tool
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-spork'
  gem 'guard-cucumber'
  # gem 'guard-livereload'

  # FSEvent & Notifications for guard
  if RUBY_PLATFORM =~ /darwin/
    gem 'rb-fsevent', :require => false
    gem 'growl', :require => false
  end
  
  gem 'sinatra'
  gem 'foreman'
end

# App Servers
gem 'passenger'
gem 'thin'

# Deploy with Capistrano
gem 'capistrano'


