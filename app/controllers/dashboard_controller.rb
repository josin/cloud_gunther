class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /
  def index
    
    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @algorithm_binaries }
    end
  end
  
end
