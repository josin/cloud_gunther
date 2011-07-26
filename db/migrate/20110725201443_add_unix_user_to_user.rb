class AddUnixUserToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :unix_username, :string
  end

  def self.down
    remove_column :users, :unix_username
  end
end