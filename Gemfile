source 'http://rubygems.org'

gem 'rails'
gem 'mysql2'  

gem 'devise'
gem 'cancan'

gem 'paperclip'
gem 'will_paginate', ">=3.0.pre2"
gem 'simple-navigation'

gem 'meta_where'
gem 'meta_search'

gem 'amqp'
gem 'qusion'
gem 'right_aws'
gem 'delayed_job'

gem 'popen4'

gem 'awesome_print', :require => 'ap'

group :development do
  # debugger
  unless defined?(JRUBY_VERSION)
    gem 'ruby-debug' unless RUBY_VERSION == "1.9.2"
    gem 'ruby-debug19' if RUBY_VERSION == "1.9.2"
  end
end


group :development, :test do
  gem 'rspec-rails', '>= 2.4.1'
  gem 'spork', '>= 0.9.0.rc5'
  gem 'simplecov', '>=0.3.8', :require => false
end

# Use * as the web server
gem 'thin'

# Deploy with Capistrano
gem 'capistrano'


