class AddCloudEngineIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :cloud_engine_id, :integer
    add_column :tasks, :task_params, :text
  end

  def self.down
    remove_column :tasks, :task_params
    remove_column :tasks, :cloud_engine_id
  end
end