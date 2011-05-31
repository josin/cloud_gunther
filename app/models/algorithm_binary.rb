# == Schema Information
# Table name: algorithm_binaries
# Fields: id, algorithm_id, user_id, description, version, 
#         state, launch_params, created_at, updated_at, #

class AlgorithmBinaryValidator < ActiveModel::Validator
  def validate(record)
    if record.attachment and !record.attachment.valid?
      record.attachment.errors.each_value { |error| record.errors[:base] << error }
    end
    
    options[:fields].presence.each do |field|
      if field == :state
        if record.state == "enabled" and record.state_changed? and record.attachment.nil?
          record.errors[:base] << "For enabling binary you must upload binary data executable."
        end
      end
    end
  end # of validate
end # of class

class AlgorithmBinary < ActiveRecord::Base
  extend ActiveModel::Callbacks
  # after_save :action_after_save
  
  belongs_to :algorithm
  belongs_to :user
  
  has_one :attachment, :as => :attachable, :dependent => :destroy
  
  attr_accessible :id, :description, :version, :state, :launch_params, :attachment
  
  # accepts_nested_attributes_for :attachment
  
  validates_presence_of :version
  validates_presence_of :algorithm_id, :on => :create
  # validates_with AlgorithmBinaryValidator, :fields => [:state]
  
  scope :active, where(:state => "enabled")
  
  def name
    "#{self.algorithm.name} - #{self.version}"
  end
  
  # def to_param
  #   "#{self.id}-#{self.version.parameterize}"
  # end
  
  def prepare_launch_cmd
    self.launch_params.blank? ? self.algorithm.launch_params : self.launch_params
  end
  
  private
  def action_after_save
    if self.attachment.changed?
      self.attachment.attachable = self
      self.attachment.save
    end
  end
end # of class

