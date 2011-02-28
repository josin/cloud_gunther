class AddAdminFlagToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :admin, :boolean, :default => false
    add_column :users, :state, :string
  end

  def self.down
    remove_column :users, :state
    remove_column :users, :admin
  end
end
