class DelayedJobsController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /delayed_jobs
  # GET /delayed_jobs.xml
  def index
    @search = DelayedJob.metasearch(params[:search])
    @delayed_jobs = DelayedJob.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @delayed_jobs }
    end
  end

  # GET /delayed_jobs/1
  # GET /delayed_jobs/1.xml
  def show
    @delayed_job = DelayedJob.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @delayed_job }
    end
  end

  # # GET /delayed_jobs/new
  # # GET /delayed_jobs/new.xml
  # def new
  #   @delayed_job = DelayedJob.new
  # 
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @delayed_job }
  #   end
  # end
  # 
  # # GET /delayed_jobs/1/edit
  # def edit
  #   @delayed_job = DelayedJob.find(params[:id])
  # end
  # 
  # # POST /delayed_jobs
  # # POST /delayed_jobs.xml
  # def create
  #   @delayed_job = DelayedJob.new(params[:delayed_job])
  # 
  #   respond_to do |format|
  #     if @delayed_job.save
  #       format.html { redirect_to(@delayed_job, :notice => 'Delayed job was successfully created.') }
  #       format.xml  { render :xml => @delayed_job, :status => :created, :location => @delayed_job }
  #     else
  #       format.html { render :action => "new" }
  #       format.xml  { render :xml => @delayed_job.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end
  # 
  # # PUT /delayed_jobs/1
  # # PUT /delayed_jobs/1.xml
  # def update
  #   @delayed_job = DelayedJob.find(params[:id])
  # 
  #   respond_to do |format|
  #     if @delayed_job.update_attributes(params[:delayed_job])
  #       format.html { redirect_to(@delayed_job, :notice => 'Delayed job was successfully updated.') }
  #       format.xml  { head :ok }
  #     else
  #       format.html { render :action => "edit" }
  #       format.xml  { render :xml => @delayed_job.errors, :status => :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /delayed_jobs/1
  # DELETE /delayed_jobs/1.xml
  def destroy
    @delayed_job = DelayedJob.find(params[:id])
    @delayed_job.destroy

    respond_to do |format|
      format.html { redirect_to(delayed_jobs_url) }
      format.xml  { head :ok }
    end
  end
end
