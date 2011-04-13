class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images, :force => true do |t|
      t.string :title
      t.text :description

      t.integer :cloud_engine_id

      t.text :launch_params
      t.text :start_up_script

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
