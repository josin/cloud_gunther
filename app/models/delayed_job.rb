# == Schema Information
# Table name: delayed_jobs
# Fields: id, priority, attempts, handler, last_error, 
#         run_at, locked_at, failed_at, locked_by, created_at, 
#         updated_at, #

class DelayedJob < ActiveRecord::Base
end
