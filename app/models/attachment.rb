# == Schema Information
# Table name: attachments
# Fields: id, attachable_id, attachable_type, data_file_name, data_content_type, 
#         data_file_size, created_at, updated_at, user_id, #

class Attachment < ActiveRecord::Base
  has_attached_file :data, # Paperclip::Attachment instance
                    :url  => "/attachments/:id/:basename.:extension",
                    :path => ":rails_root/public/uploads/:id/:basename.:extension"
  
  belongs_to :attachable, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :user_id, :on => :create
  
  def to_param
    "#{self.id}-#{self.data.original_filename.parameterize}"
  end
  
  def image?
    self.data_content_type =~ /^image/i
  end
  
  def inlineable?
    image? || self.data_content_type =~ /^application\/pdf/i
  end
  
end
