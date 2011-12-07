class AddAttemptsAndErrorsToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :attempts, :integer, :default => 0
    add_column :tasks, :error_msg, :text
    add_column :tasks, :failed_at, :datetime
  end

  def self.down
    remove_column :tasks, :failed_at
    remove_column :tasks, :error_msg
    remove_column :tasks, :attempts
  end
end