class ImagesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /images
  # GET /images.xml
  def index
    @search = Image.metasearch(params[:search])
    @images = @search.all.paginate(:page => @page, :per_page => @per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @images }
    end
  end

  # GET /images/1
  # GET /images/1.xml
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/new
  # GET /images/new.xml
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.xml
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to(@image, :notice => 'Image was successfully created.') }
        format.xml  { render :xml => @image, :status => :created, :location => @image }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.xml
  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to(@image, :notice => 'Image was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @image.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.xml
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to(images_url) }
      format.xml  { head :ok }
    end
  end
  
  # POST /images/1/verify_availability
  def verify_availability
    @output = ""
    @error = false
    
    begin
      image_description = @image.describe_image!
      @output = "Image description: #{image_description.pretty_inspect}"
    rescue Exception => e
      @error = true
      @output = "Image could not be estabilished due to following errors: #{e.message}"
    end    

    respond_to do |format|
      format.html { redirect_to(@image, :notice => @output) } unless @error
      format.html { redirect_to(@image, :alert => @output) } if @error
    end
  end
  
  private
  def setup
    @title << "Admin"
    @title << "Images"
  end
end
