# == Schema Information
# Table name: users
# Fields: id, first_name, last_name, email, encrypted_password, 
#         password_salt, remember_token, remember_created_at, sign_in_count, current_sign_in_at, 
#         last_sign_in_at, current_sign_in_ip, last_sign_in_ip, failed_attempts, locked_at, 
#         admin, state, #

class User < ActiveRecord::Base
  extend ActiveModel::Callbacks
  before_save :action_before_save
  
  ENABLED = "enabled"
  DISABLED = "disabled"
  STATES = [ENABLED, DISABLED]
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :recoverable, 
  # :registerable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable, :registerable, :lockable
        
  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me,
                  :admin, :state
  
  validates_presence_of :first_name, :last_name

  has_many :tasks
  has_many :algorithms
  has_many :algorithm_binaries
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
  
  private
  def action_before_save
    if state_changed?
      case self.state
        when ENABLED
          self.locked_at = nil
        when DISABLED
          self.locked_at = Time.now
      end
    end
  end
end
