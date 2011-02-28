class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.datetime :started_at
      t.datetime :finished_at
      t.text :params
      t.text :inputs
      t.string :state
      t.integer :user_id
      t.integer :algorithm_binary_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
