class ApplicationController < ActionController::Base
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  before_filter :global_setup, :setup
  
  protected
  def setup
  end
  
  private
  def global_setup
    @title = []
    
    @page = params[:page].presence || 1
    WillPaginate.per_page = params[:per_page].presence || AppConfig.config[:per_page].presence || 25 
  end
end
