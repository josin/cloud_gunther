# Rails runner script
# How to run this script?
# => TASK_ID=100 CLONES=1000 (bundle exec) rails runner PATH_TO-clone_tasks.rb

@task_id = ENV["TASK_ID"] || 1
@clones = ENV["CLONES"] || 10

puts "Generating #{@clones} clones of task##{@task_id}."

@task = Task.find @task_id
puts @task.inspect

@random = Random.new(Time.now.to_i)
@new_tasks = []

@clones.to_i.times do |i|
  cloned_task = @task.clone
  cloned_task.priority = @random.rand(100)
  cloned_task.save
  @new_tasks << cloned_task
end

puts "Expected running order:"
@new_tasks.sort { |a,b| a.priority <=> b.priority }.reverse.each do |task|
  puts "<Task##{task.id}: priority: #{task.priority}>"
end

puts "Running all tasks: #{@new_tasks.map(&:id)}"
@new_tasks.each { |task| task.update_attribute(:state, Task::STATES[:ready]) }

puts "finished."
