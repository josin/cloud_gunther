class TaskRunner
  @queue = :tasks_queue
  
  def self.perform(task_id)
    task = Task.find(task_id)
    begin
      task.run
    rescue Exception => e
      task.update_attributes!({:state => STATES[:failed], :error_msg => e.message, :failed_at => Time.now})
      logger.error { "Error when running task##{task.id}: #{e.message}\n#{e.backtrace}" }
    end
  end
end