class UsersController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  
  # GET /users
  # GET /users.xml
  def index
    @search = User.metasearch(params[:search])
    @users = @search.where(:state ^ 'new').paginate(:page => @page, :per_page => @per_page)
    
    @pending_registrations_count = User.where(:state => 'new').count
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  # GET /tokeninput.json
  def tokeninput
    @users = User.where(:state => User::ENABLED).where((:first_name =~ "%#{params[:q]}%") | (:last_name =~ "%#{params[:q]}%"))

    # logger.info { "Found #{@users.length} users." }
    respond_to do |format|
      format.json { render :json => @users.map { |v| { :id => v.id, :name => v.name } } }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # GET /users/1/change_password
  def change_password
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html do
          action_to_render = ("Change password" == params[:commit].presence) ? "change_password" : "edit"
          render :action => action_to_render
        end
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /users/registrations
  # GET /users/registrations.xml
  def registrations
    @search = User.metasearch(params[:search])
    @users = @search.where(:state => 'new').paginate(:page => @page, :per_page => @per_page)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  # POST /users/1/approve
  # POST /users/1/approve.xml
  def approve
    @user.state = User::ENABLED
    @user.save
    
    respond_to do |format|
      format.html { redirect_to(registrations_users_path, :notice => "User registration was successfully approved.") }
      format.xml  { head :ok }
    end
  end
  
  # POST /users/1/reject
  # POST /users/1/reject.xml
  def reject
    @user.destroy
    
    respond_to do |format|
      format.html { redirect_to(registrations_users_path, :notice => "User registration was successfully rejected and deleted.") }
      format.xml  { head :ok }
    end
  end
  
  private
  def setup
    @title << [ "Admin", "Users" ]
  end
end
