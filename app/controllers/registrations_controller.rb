class RegistrationsController < Devise::RegistrationsController
  
  # only :edit and :udpate actions could have application layout
  layout Proc.new { |controller|
    ["edit", "update"].include?(controller.request.params[:action]) ? 'application' : 'login'
  }
  
  def new
    @title = ["Sign up"]
    super
  end
  
  private
  def setup
    @title << "My Account"
  end
  
end
