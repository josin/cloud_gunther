# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron
# 
# Learn more: http://github.com/javan/whenever

set :output, "#{Rails.root}/log/cron_log.log"

every 2.minutes do
  runner "Daemons::OutputsWorker.run"
end

every 2.minutes do
  runner "Daemons::InstanceService.run"
end

