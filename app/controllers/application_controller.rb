class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  before_filter :global_setup
  
  private
  def global_setup
    @page = params[:page].presence || 1
    @per_page = params[:per_page].presence || 10 
  end
end
