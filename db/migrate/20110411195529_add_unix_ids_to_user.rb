class AddUnixIdsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :unix_uid, :integer
  end

  def self.down
    remove_column :users, :unix_uid
  end
end
