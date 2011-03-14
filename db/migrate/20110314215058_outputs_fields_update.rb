class OutputsFieldsUpdate < ActiveRecord::Migration
  def self.up
    rename_column :outputs, :output, :stdout
    add_column :outputs, :stderr, :text, :after => :stdout
  end

  def self.down
    remove_column :outputs, :stderr
    rename_column :outputs, :stdout, :output
  end
end
