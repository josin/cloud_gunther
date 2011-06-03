class AddImageIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :image_id, :integer
  end

  def self.down
    remove_column :tasks, :image_id
  end
end