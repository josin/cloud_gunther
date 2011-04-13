class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      
      t.boolean :admin, :default => false
      t.string :state
      t.timestamps
      
      # Devise authentication
      t.database_authenticatable :null => false
      t.encryptable
      t.rememberable
      t.trackable
      t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :none
      t.token_authenticatable
      t.recoverable
      # t.confirmable
    end
    
    add_index :users, :email, :unique => true
    add_index :users, :authentication_token, :unique => true
    # add_index :users, :authentication_token, :unique => true
    # add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
  end

  def self.down
    drop_table :users
  end
end
