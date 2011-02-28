# == Schema Information
# Table name: algorithm_binaries
# Fields: id, algorithm_id, description, version, state, 
#         launch_params, created_at, updated_at, #

class AlgorithmBinary < ActiveRecord::Base
  belongs_to :algorithm
  
  has_one :attachment, :as => :attachable, :dependent => :destroy
  
  attr_accessible :id, :description, :version, :state, :launch_params, :attachment
  
  # accepts_nested_attributes_for :attachment
  
  validates_presence_of :version
  validates_presence_of :algorithm_id, :on => :create
  
  scope :active, where(:state => "enabled")
  
  def name
    "#{self.algorithm.name} #{self.version}"
  end
  
  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end
end
