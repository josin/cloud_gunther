#!/usr/bin/env ruby

%w{rubygems net/ssh net/scp}.each { |lib| require lib }

HOST = 'ubnt'
USER = 'josin'
SCRIPT_NAME = "runner.rb"

Net::SSH.start(HOST, USER) do |ssh|
  # Transfer script on the server
  ssh.scp.upload! "#{SCRIPT_NAME}", "#{SCRIPT_NAME}" do |ch, name, sent, total|
    puts "#{name}: #{sent}/#{total}"
  end

  # Run script on remote side
  # puts ssh.exec! "source /etc/profile.d/rvm.sh; rvm --version"
  # TODO: add su command to run alg with correct user id
  puts ssh.exec! "source /etc/profile.d/rvm.sh; nohup ruby #{SCRIPT_NAME} > out.log 2>&1 &"
end



