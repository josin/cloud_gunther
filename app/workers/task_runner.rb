class TaskRunner
  @queue = :tasks_queue
  
  def self.perform(task_id)
    task = Task.find(task_id)
    task.run
  end
end