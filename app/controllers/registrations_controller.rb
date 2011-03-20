class RegistrationsController < Devise::RegistrationsController
  
  # only :edit and :udpate actions could have application layout
  layout Proc.new { |controller|
    ["edit", "update"].include?(controller.request.params[:action]) ? 'application' : 'login'
  }
  
  # GET /account/sign_up
  def new
    @title = ["Sign up"]
    super
  end
  
  # POST /account
  def create
    @user = User.new(params[:user])
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to(new_user_session_path, :notice => 'User registration complete. Your account will not be active until administrator confirmation.') }
      else
        format.html { render :action => "new" }
      end
    end
    
  end
  
  private
  def setup
    @title << "My Account"
  end
  
end
