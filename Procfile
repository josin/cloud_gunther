rails: rails server -u thin
scheduler: ruby ./lib/daemons/scheduler_ctl.rb run -t
instance_worker: ruby ./lib/daemons/instance_service_ctl.rb run -t
outputs_worker: ruby ./lib/daemons/outputs_worker_ctl.rb run -t
resque_worker: ruby ./lib/daemons/resque_worker_ctl.rb run -t

