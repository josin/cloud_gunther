class AlgorithmsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_algorithm, :except => [:index, :new, :create]
  
  
  # GET /algorithms
  # GET /algorithms.xml
  def index
    @search = Algorithm.where(nil) if current_user.admin?
    @search = current_user.algorithms unless current_user.admin?

    @search = @search.metasearch(params[:search])
    @algorithms = @search.paginate(:page => @page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @algorithms }
    end
  end

  # GET /algorithms/1
  # GET /algorithms/1.xml
  def show
    
    @search = @algorithm.algorithm_binaries.metasearch(params[:search])
    @algorithm_binaries = @search.paginate(:page => @page)

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
    @algorithm.destroy

    respond_to do |format|
      format.html { redirect_to(algorithms_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_algorithm
    @algorithm = Algorithm.find(params[:id])
    authorize! :manage, @algorithm
  end
  
  def setup
    @title << "Algorithms"
  end
  
end
