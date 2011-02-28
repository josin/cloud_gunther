class CreateAttachments < ActiveRecord::Migration
  def self.up
    create_table :attachments do |t|
      t.integer  :attachable_id
      t.string   :attachable_type

      t.string   :data_file_name
      t.string   :data_content_type
      t.integer  :data_file_size

      t.timestamps
    end
    
    add_index :attachments, [:attachable_id, :attachable_type]      
  end

  def self.down
    drop_table :attachments
  end
end
