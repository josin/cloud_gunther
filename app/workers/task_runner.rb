class TaskRunner
  @queue = :tasks_queue
  
  def self.perform(task_id)
    task = Task.find(task_id)
    begin
      task.run
    rescue Exception => e
      task.failure! e.message
      logger.error { "Error when running task##{task.id}: #{e.message}\n#{e.backtrace.join("\n")}" }
    end
  end
end