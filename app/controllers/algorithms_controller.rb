class AlgorithmsController < ApplicationController
  before_filter :authenticate_user!
  
  
  # GET /algorithms
  # GET /algorithms.xml
  def index
    @search = Algorithm.metasearch(params[:search])
    @algorithms = @search.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @algorithms }
    end
  end

  # GET /algorithms/1
  # GET /algorithms/1.xml
  def show
    @algorithm = Algorithm.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @algorithm }
    end
  end

  # GET /algorithms/new
  # GET /algorithms/new.xml
  def new
    @algorithm = Algorithm.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @algorithm }
    end
  end

  # GET /algorithms/1/edit
  def edit
    @algorithm = Algorithm.find(params[:id])
  end

  # POST /algorithms
  # POST /algorithms.xml
  def create
    @algorithm = Algorithm.new(params[:algorithm])
    @algorithm.user = current_user

    respond_to do |format|
      if @algorithm.save
        format.html { redirect_to(@algorithm, :notice => 'Algorithm was successfully created.') }
        format.xml  { render :xml => @algorithm, :status => :created, :location => @algorithm }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @algorithm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /algorithms/1
  # PUT /algorithms/1.xml
  def update
    @algorithm = Algorithm.find(params[:id])

    respond_to do |format|
      if @algorithm.update_attributes(params[:algorithm])
        format.html { redirect_to(@algorithm, :notice => 'Algorithm was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @algorithm.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /algorithms/1
  # DELETE /algorithms/1.xml
  def destroy
    @algorithm = Algorithm.find(params[:id])
    @algorithm.destroy

    respond_to do |format|
      format.html { redirect_to(algorithms_url) }
      format.xml  { head :ok }
    end
  end
end
