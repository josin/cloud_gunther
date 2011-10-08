class AlgorithmBinariesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_algorithm
  
  # GET /algorithm_binaries
  # GET /algorithm_binaries.xml
  def index
    @algorithm_binaries = @algorithm.algorithm_binaries

    respond_to do |format|
      format.js { render :layout => false, :partial => 'algorithm_binaries/options_list' }
      format.html # index.html.erb
      format.xml  { render :xml => @algorithm_binaries }
    end
  end

  # GET /algorithm_binaries/1
  # GET /algorithm_binaries/1.xml
  def show
    @algorithm_binary = AlgorithmBinary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @algorithm_binary }
    end
  end

  # GET /algorithm_binaries/new
  # GET /algorithm_binaries/new.xml
  def new
    @algorithm_binary = AlgorithmBinary.new
    @algorithm_binary.algorithm = @algorithm

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @algorithm_binary }
    end
  end

  # GET /algorithm_binaries/1/edit
  def edit
    @algorithm_binary = AlgorithmBinary.find(params[:id])
  end

  # POST /algorithm_binaries
  # POST /algorithm_binaries.xml
  def create
    @algorithm_binary = AlgorithmBinary.new
    @algorithm_binary.algorithm = @algorithm
    @algorithm_binary.user = current_user
    
    process_attachments
    
    respond_to do |format|
      if @algorithm_binary.update_attributes(params[:algorithm_binary])
        format.html { redirect_to(@algorithm, :notice => 'Algorithm binary was successfully created.') }
        format.xml  { render :xml => @algorithm_binary, :status => :created, :location => @algorithm_binary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @algorithm_binary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /algorithm_binaries/1
  # PUT /algorithm_binaries/1.xml
  def update
    @algorithm_binary = AlgorithmBinary.find(params[:id])
    
    process_attachments
    
    respond_to do |format|
      if @algorithm_binary.update_attributes(params[:algorithm_binary])
        format.html { redirect_to(@algorithm, :notice => 'Algorithm binary was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @algorithm_binary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /algorithm_binaries/1
  # DELETE /algorithm_binaries/1.xml
  def destroy
    @algorithm_binary = AlgorithmBinary.find(params[:id])
    @algorithm_binary.destroy

    respond_to do |format|
      format.html { redirect_to(@algorithm, :notice => 'Algorithm binary was deleted.') }
      format.xml  { head :ok }
    end
  end
  
  private
  def find_algorithm
    @algorithm = Algorithm.find(params[:algorithm_id])
    authorize! :manage, @algorithm
  end
  
  def process_attachments
    if params[:algorithm_binary].present? and params[:algorithm_binary][:attachment].present?
      @algorithm_binary.attachment = Attachment.new params[:algorithm_binary].delete :attachment
      @algorithm_binary.attachment.user = current_user
    end
  end
  
  def setup
    @title << [ "Algorithms", "Binaries" ]
  end
end
