class CreateAlgorithms < ActiveRecord::Migration
  def self.up
    create_table :algorithms do |t|
      t.string :name
      t.string :group
      t.integer :author_id
      t.string :description
      t.string :launch_params

      t.timestamps
    end
  end

  def self.down
    drop_table :algorithms
  end
end
