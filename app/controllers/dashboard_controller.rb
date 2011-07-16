require 'net/http'
require 'net/https'
require 'uri'

class DashboardController < ApplicationController
  before_filter :authenticate_user!
  
  # GET /
  def index
    @tasks = Task.order(:id.desc).limit(5)
    @tasks.where(:user_id => current_user.id) unless current_user.admin?
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /dashboard/queues.json
  def queues
    amqp_config = AppConfig.amqp_config
    
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

