source 'http://rubygems.org'

gem 'rails', '3.0.5'

group :production do
  gem 'sqlite3' # AWS Free Account has no SQL DB included
end

group :development, :test do
  gem 'mysql2'  
end

gem 'devise'
gem 'cancan'

gem 'paperclip'
gem 'will_paginate', ">=3.0.pre2"
gem 'simple-navigation'

gem 'meta_where'
gem 'meta_search'

gem 'amqp'
gem 'right_aws'
gem 'delayed_job'
gem 'popen4'


group :development do
  gem 'awesome_print', :require => 'ap'
  
  # debugger
  unless defined?(JRUBY_VERSION)
    gem 'ruby-debug' unless RUBY_VERSION == "1.9.2"
    gem 'ruby-debug19' if RUBY_VERSION == "1.9.2"
  end
end


group :development, :test do
  gem 'rspec-rails', '>= 2.4.1'
  gem 'spork', '~> 0.9.0.rc'
  gem 'simplecov', '>=0.3.8', :require => false
end

# Use * as the web server
gem 'thin'

# Deploy with Capistrano
gem 'capistrano'


