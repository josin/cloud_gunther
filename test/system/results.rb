
@task_ids = ENV["TASKS"] || []
@task_ids = eval(@task_ids) if !@task_ids.blank? and @task_ids.is_a?(String)

@tasks = []
@task_ids.each { |id| @tasks << Task.find(id) }

puts "Tasks finished with following status and order:"
@tasks.sort { |a,b| a.finished_at <=> b.finished_at }.each do |task|
  puts "<Task##{task.id}: priority: #{task.priority}, started_at: #{task.started_at}, finished_at: #{task.finished_at}>"
end

