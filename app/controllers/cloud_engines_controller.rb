class CloudEnginesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /cloud_engines
  # GET /cloud_engines.xml
  def index
    @search = CloudEngine.metasearch(params[:search])
    @cloud_engines = @search.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cloud_engines }
    end
  end

  # GET /cloud_engines/1
  # GET /cloud_engines/1.xml
  def show
    @cloud_engine = CloudEngine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cloud_engine }
    end
  end

  # GET /cloud_engines/new
  # GET /cloud_engines/new.xml
  def new
    @cloud_engine = CloudEngine.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cloud_engine }
    end
  end

  # GET /cloud_engines/1/edit
  def edit
    @cloud_engine = CloudEngine.find(params[:id])
  end

  # POST /cloud_engines
  # POST /cloud_engines.xml
  def create
    @cloud_engine = CloudEngine.new(params[:cloud_engine])

    respond_to do |format|
      if @cloud_engine.save
        format.html { redirect_to(@cloud_engine, :notice => 'Cloud engine was successfully created.') }
        format.xml  { render :xml => @cloud_engine, :status => :created, :location => @cloud_engine }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cloud_engine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cloud_engines/1
  # PUT /cloud_engines/1.xml
  def update
    @cloud_engine = CloudEngine.find(params[:id])

    respond_to do |format|
      if @cloud_engine.update_attributes(params[:cloud_engine])
        format.html { redirect_to(@cloud_engine, :notice => 'Cloud engine was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cloud_engine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_engines/1
  # DELETE /cloud_engines/1.xml
  def destroy
    @cloud_engine = CloudEngine.find(params[:id])
    @cloud_engine.destroy

    respond_to do |format|
      format.html { redirect_to(cloud_engines_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def setup
    @title << "Admin"
    @title << "Cloud Engines"
  end
  
end
