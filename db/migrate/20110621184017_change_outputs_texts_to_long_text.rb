class ChangeOutputsTextsToLongText < ActiveRecord::Migration
  def self.up
    change_column :outputs, :stdout, :longtext
    change_column :outputs, :stderr, :longtext
  end

  def self.down
    change_column :outputs, :stdout, :text
    change_column :outputs, :stderr, :text
  end
end