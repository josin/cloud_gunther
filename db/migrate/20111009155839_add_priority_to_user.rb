class AddPriorityToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :priority, :integer
  end

  def self.down
    remove_column :users, :priority
  end
end