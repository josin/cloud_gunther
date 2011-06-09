class AddParamsToCloudEngine < ActiveRecord::Migration
  def self.up
    add_column :cloud_engines, :params, :text
  end

  def self.down
    remove_column :cloud_engines, :params
  end
end