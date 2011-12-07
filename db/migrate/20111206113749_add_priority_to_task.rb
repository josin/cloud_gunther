class AddPriorityToTask < ActiveRecord::Migration
  def self.up
    add_column :tasks, :priority, :float
    
    say_with_time "Updating Tasks priorities" do
      Task.all.each do |task|
        say "Updating task##{task.id}...", true
        task.update_attributes!(:priority => task.user.real_priority) if task.user
      end
    end
  end

  def self.down
    remove_column :tasks, :priority
  end
end