source 'http://rubygems.org'

gem 'rails', '3.0.9'

gem 'mysql2', '0.2.7'

gem 'devise'
gem "cancan", "~> 1.6.7"

gem 'paperclip'
gem 'will_paginate', ">=3.0.pre2"
gem 'simple-navigation'

gem 'meta_where'
gem 'meta_search'

gem 'amqp'
gem 'bunny'
# gem 'right_aws', '2.0.0'
gem 'right_aws'
gem 'delayed_job'

gem 'net-ssh'
gem 'net-scp'
gem 'popen4'

gem 'daemons'
gem 'whenever'

gem 'awesome_print', :require => 'ap'

group :development do
  # debugger
  gem 'ruby-debug19' if RUBY_VERSION == "1.9.2"
  gem 'ruby-debug' unless RUBY_VERSION == "1.9.2"
end


group :development, :test do
  gem 'rspec-rails'
  gem 'spork', '~> 0.9.0.rc'

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
  gem 'rb-fsevent', :require => false
  gem 'growl', :require => false
  
  # Instance service consumer
  gem 'sinatra'
end

# App Servers
gem 'passenger'

# Deploy with Capistrano
gem 'capistrano'


