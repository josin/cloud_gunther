class AddParamsToOutput < ActiveRecord::Migration
  def self.up
    add_column :outputs, :params, :text
  end

  def self.down
    remove_column :outputs, :params
  end
end
