class DeleteDelayedJobs < ActiveRecord::Migration
  def self.up
    # drop_table :delayed_jobs
  end

  def self.down
    say "use rails generate delayed_job"
  end
end
