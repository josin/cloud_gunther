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
    
    @instances = fetch_instances_info(@task)
    
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
    run_opts = {}

    if @task.algorithm_binary.attachment
      run_opts[:algorithm_url] = url_for(attachment_path(:id => @task.algorithm_binary.attachment.id, 
                                                         :auth_token => current_user.authentication_token,
                                                         :host => AppConfig.config[:host],
                                                         :only_path => false))
      run_opts[:algorithm_filename] = @task.algorithm_binary.attachment.data_file_name
    end    
    
    @task.run(run_opts)
    
    @task.state = Task::STATES[:ready]
    @task.started_at = Time.now
    @task.save
    
    respond_to do |format|
      format.html { redirect_to(@task, :notice => 'Task is running.') }
      format.xml  { head :ok }
    end
  end
  
  # GET /tasks/cloud_engine_availability_zones_info?cloud_engine_id
  def cloud_engine_availability_zones_info
    @cloud_engine = CloudEngine.find params[:cloud_engine_id]
    
    # TODO: works only for Eucalyptus
    zones_info = VerboseAvailabilityZonesInfo.get_info(@cloud_engine.availability_zones_info_cmd) if @cloud_engine.eucalyptus?
    
    respond_to do |format|
      format.js do
        if zones_info
          render :partial => "shared/eucalyptus_availability_zones_info", :locals => { :zones_info => zones_info }
        else
          render :text => "Availablity zones info not available."
        end
      end
    end
  end
  
  # GET /tasks/cloud_engine_zones?cloud_engine_id
  def cloud_engine_zones
    @cloud_engine = CloudEngine.find params[:cloud_engine_id]
    zones_info = @cloud_engine.connect!.describe_availability_zones

    respond_to do |format|
      format.json { render :json => zones_info.collect{ |i| i[:zone_name] } }
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
  
  def fetch_instances_info(task)
    connection = task.cloud_engine.connect!
    connection.describe_instances(@task.task_params[:instances])
  rescue
    logger.error { "Could not connect to cloud engine id: #{task.cloud_engine.id}" }
    return []
  end
  
  def setup
    @title << "Tasks"
  end
end
