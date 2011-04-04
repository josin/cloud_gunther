class CreateCloudEngines < ActiveRecord::Migration
  def self.up
    create_table :cloud_engines, :force => true do |t|
      t.string :title
      t.string :engine_type
      t.string :access_key
      t.string :secret_access_key
      t.string :endpoint_url

      t.timestamps
    end
  end

  def self.down
    drop_table :cloud_engines
  end
end
