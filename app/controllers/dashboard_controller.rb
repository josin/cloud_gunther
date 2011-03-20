require 'net/http'
require 'uri'

class DashboardController < ApplicationController
  before_filter :authenticate_user!
  before_filter :get_queue_status, :only => [:index]
  
  # GET /
  def index
    @search = Task.where(nil) if current_user.admin?
    @search = current_user.tasks unless current_user.admin?

    @search = @search.running.metasearch(params[:search])
    @tasks = @search.paginate(:page => @page, :per_page => @per_page)
    
    respond_to do |format|
      format.html # index.html.erb
      # format.xml  { render :xml => @algorithm_binaries }
    end
  end
  
  private
  def get_queue_status
    begin
      url = URI.parse("http://#{AMQP.settings[:host]}:#{AMQP.settings[:port]}/api/queues")
      req = Net::HTTP::Get.new(url.path)
      req.basic_auth "#{AMQP.settings[:user]}", "#{AMQP.settings[:pass]}"
      res = Net::HTTP.new(url.host, url.port).start do |http| 
        response = http.request(req)
        response_json = JSON.parse(response.body)
        @waiting_tasks = response_json.select { |item| item["name"] == "tasks" }.first["messages"]
      end
    rescue
      @waiting_tasks ||= 0
    end
  end
  
  def setup
    @title << "Dashboard"
  end
end
