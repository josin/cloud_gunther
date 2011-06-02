class AddAttachmentTypeToAttachments < ActiveRecord::Migration
  def self.up
    add_column :attachments, :attachment_type, :string 
  end

  def self.down
    remove_column :attachments, :attachment_type
  end
end
