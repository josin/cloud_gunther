class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images, :force => true do |t|
      t.string :name
      t.text :description
      t.integer :cloud_engine_id
      t.string :image_type

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
