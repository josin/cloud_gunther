class RenameAlgorithmAuthorId < ActiveRecord::Migration
  def self.up
    rename_column :algorithms, :author_id, :user_id
  end

  def self.down
    rename_column :algorithms, :user_id, :author_id
  end
end
