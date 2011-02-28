class CreateAlgorithmBinaries < ActiveRecord::Migration
  def self.up
    create_table :algorithm_binaries do |t|
      t.integer :algorithm_id
      t.integer :user_id
      t.text :description
      t.string :version
      t.string :state
      t.string :launch_params

      t.timestamps
    end
  end

  def self.down
    drop_table :algorithm_binaries
  end
end
