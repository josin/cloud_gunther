class TasksController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_task, :except => [:index, :new, :create]
  
  # GET /tasks
  # GET /tasks.xml
  def index
    @search = Task.where(nil) if current_user.admin?
    @search = current_user.tasks unless current_user.admin?

    @search = @search.metasearch(params[:search])
    @tasks = @search.all.paginate(:page => @page, :per_page => @per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @search = @task.outputs.metasearch(params[:search])
    @outputs = @search.all.paginate(:page => @page, :per_page => @per_page)
    
    @title << "##{@task.id}"

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
    
    # => run is asynchronous method via delayed_job
    @task.run(:algorithm_url => url_for(attachment_path(:id => @task.algorithm_binary.attachment.id, 
                                                        :auth_token => current_user.authentication_token,
                                                        :host => AppConfig.config[:host],
                                                        :only_path => false)))
    @task.update_attribute(:state, Task::STATES[:ready])
    
    respond_to do |format|
      format.html { redirect_to(@task, :notice => 'Task is running.') }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_task
    task_id = params[:id] || params[:task_id]
    @task = Task.find(task_id)
    authorize! :manage, @task
  end
  
  def setup
    @title << "Tasks"
  end
end
