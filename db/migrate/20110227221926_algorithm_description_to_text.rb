class AlgorithmDescriptionToText < ActiveRecord::Migration
  def self.up
    change_column :algorithms, :description, :text
  end

  def self.down
    change_column :algorithms, :description, :string
  end
end
