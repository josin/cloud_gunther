require 'net/http'
require 'net/https'
require 'uri'

class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /
  def index
    @search = Task.where(nil) if current_user.admin?
    @search = current_user.tasks unless current_user.admin?

    @search = @search.limit(10).metasearch(params[:search])
    @tasks = @search.paginate(:page => @page, :per_page => @per_page)
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /dashboard/queues.json
  def queues
    amqp_config = AmqpConfig.config
    
    url = URI.parse("http#{'s' if amqp_config[:ssl]}://#{amqp_config[:host]}:55672/api/queues")
    req = Net::HTTP::Get.new(url.path) 
    req.basic_auth "#{amqp_config[:user]}", "#{amqp_config[:pass]}"
    res = Net::HTTP.new(url.host, url.port).start { |http| http.request(req) }
    
    respond_to do |format|
      format.json  { render :json => res.body }
    end
  end
  
  private
  def setup
    @title << "Dashboard"
  end
end

