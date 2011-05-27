class ConvertTaskParamsToText < ActiveRecord::Migration
  def self.up
    change_column :tasks, :params, :text
  end

  def self.down
    change_column :tasks, :params, :string
  end
end
