# == Schema Information
# Table name: users
# Fields: id, first_name, last_name, admin, state, 
#         email, encrypted_password, password_salt, created_at, updated_at, 
#         remember_token, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, 
#         current_sign_in_ip, last_sign_in_ip, failed_attempts, locked_at, authentication_token, 
#         reset_password_token, unix_uid, unix_username, priority, #

class User < ActiveRecord::Base
  before_create :action_before_create
  before_save :action_before_save
  
  ENABLED = "enabled"
  DISABLED = "disabled"
  STATES = [ENABLED, DISABLED]
  
  devise :encryptable, :encryptor => :sha512
  devise :database_authenticatable, :token_authenticatable,
         :rememberable, :trackable, :validatable, :registerable, :lockable
        
  # Setup accessible (or protected) attributes for your model
  # attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me,
  #                 :admin, :state, :unix_uid
  
  validates_presence_of :first_name, :last_name, :email
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  # validates_numericality_of :priority
  
  has_many :tasks
  has_many :algorithms
  has_many :algorithm_binaries
  
  has_many :user_group_assocs
  has_many :user_groups, :through => :user_group_assocs
  attr_reader :user_group_tokens
  
  def user_group_tokens=(ids)
    self.user_group_ids = ids.split(",")
  end
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  def role
    self.admin? ? "Administrator" : ""
  end
  
  def real_priority
    ([self.priority] + self.user_groups.map(&:priority)).compact.max
  end
  
  private
  def action_before_create
    # Lock new account => wait for admin aproval
    self.state = 'new'
    self.locked_at = Time.now
  end
  
  def action_before_save
    self.reset_authentication_token! if self.authentication_token.blank?
    
    if self.state_changed? and !self.new_record?
      case self.state
        when ENABLED
          self.locked_at = nil
        when DISABLED
          self.locked_at = Time.now
      end
    end
  end
end
