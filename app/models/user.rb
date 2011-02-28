# == Schema Information
# Table name: users
# Fields: id, first_name, last_name, email, encrypted_password, 
#         password_salt, remember_token, remember_created_at, sign_in_count, current_sign_in_at, 
#         last_sign_in_at, current_sign_in_ip, last_sign_in_ip, #

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable, :recoverable, 
  # :registerable
  devise :database_authenticatable,
         :rememberable, :trackable, :validatable, :registerable
        
  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation, :remember_me
  
  validates_presence_of :first_name, :last_name

  has_many :tasks
  has_many :algorithms
  
  def name
    "#{self.first_name} #{self.last_name}"
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
end
