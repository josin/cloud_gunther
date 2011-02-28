class CreateOutputs < ActiveRecord::Migration
  def self.up
    create_table :outputs do |t|
      t.integer :task_id
      t.text :output

      t.timestamps
    end
  end

  def self.down
    drop_table :outputs
  end
end
