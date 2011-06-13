# == Schema Information
# Table name: attachments
# Fields: id, attachable_id, attachable_type, data_file_name, data_content_type, 
#         data_file_size, created_at, updated_at, user_id, attachment_type, 
#         #

# TODO: max attachment size
# TODO: attachment presence validation
class Attachment < ActiveRecord::Base
  has_attached_file :data, # Paperclip::Attachment instance
                    :url  => "/attachments/:id/:basename.:extension",
                    :path => ":rails_root/public/system/attachments/:id/:basename.:extension"
  
  belongs_to :attachable, :polymorphic => true
  belongs_to :user
  
  validates_presence_of :user_id, :on => :create
  
  MAX_FILE_UPLOAD_SIZE = 1.megabyte
  VALID_FILE_TYPES = {
    :zip => { :label => "*.zip", :content_type => "application/zip" },
    :gzip => { :label => "*.gzip, *.tar.gz", :content_type => "application/x-gzip" },
    :java => { :label => "*.jar", :content_type => "application/java-archive" },
    :ruby => { :label => "*.rb", :content_type => "text/x-ruby-script" },
  }
  
  validates_attachment_presence :data
  validates_attachment_size :data, :less_than => MAX_FILE_UPLOAD_SIZE,
      :message => "Attachment is bigger than allowed file size."
  validates_attachment_content_type :data, 
      :content_type => VALID_FILE_TYPES.each_value.collect { |val| val[:content_type] },
      :message => "File type is not supported."
      
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
