class SessionsController < Devise::SessionsController
  layout 'login'
  
  private
  def setup
    @title << "Sign in"
  end
end
