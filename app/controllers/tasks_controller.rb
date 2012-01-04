class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_task, :except => [:index, :new, :create, :cloud_engine_availability_zones_info, :cloud_engine_zones]
  before_filter :find_algorithms, :only => [:new, :edit]
  
  # GET /tasks
  # GET /tasks.xml
  def index
    # Default sorting is id.desc (most recent tasks first)
    params[:search] = { :meta_sort => "id.desc" } unless params[:search].presence
    
    @search = Task.where(nil) if current_user.admin?
    @search = current_user.tasks unless current_user.admin?

    @search = @search.metasearch(params[:search])
    @tasks = @search.paginate(:page => @page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @search = @task.outputs.metasearch(params[:search])
    @outputs = @search.paginate(:page => @page, :per_page => @per_page)
    
    @title << "##{@task.id}"
    
    @instances = @task.fetch_instances_info
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])
    @task.user = current_user

    respond_to do |format|
      if @task.save
        format.html { redirect_to(@task, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end

  # POST /tasks/1/run
  def run
    # TODO: validation. Is task ready to run?
    @task.update_attributes({ :state => Task::STATES[:ready], :priority => @task.user.real_priority })
    
    # @task.update_attributes({:state => Task::STATES[:running], :started_at => Time.now})
    # Resque.enqueue(TaskRunner, @task.id)

    respond_to do |format|
      format.html { redirect_to(@task, :notice => 'Task is scheduled to run.') }
      format.xml  { head :ok }
    end
  end
  
  # POST /tasks/:id/terminate_all_instances
  def terminate_all_instances
    @task.instances.each { |instance| @task.cloud_engine.terminate_instance [instance] }
    
    respond_to do |format|
      format.html { redirect_to @task, :notice => "All instances are being terminated." }
    end
  end

  # POST /tasks/:id/terminate_instance?instance_id=:instance_id
  def terminate_instance
    instance_id = params[:instance_id].presence
    @task.cloud_engine.terminate_instance [instance_id]
    
    respond_to do |format|
      format.html { redirect_to @task, :notice => "Instance #{instance_id} is being terminated." }
    end
  end
  
  private
  def find_task
    task_id = params[:id] || params[:task_id]
    @task = Task.find(task_id)
    authorize! :manage, @task
  end
  
  def find_algorithms
    @algorithms = current_user.algorithms
    @algorithms = Algorithm.all if current_user.admin?
  end
  
  def setup
    @title << "Tasks"
  end
end
