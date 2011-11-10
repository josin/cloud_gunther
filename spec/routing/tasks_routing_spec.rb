require "spec_helper"

describe TasksController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/tasks" }.should route_to(:controller => "tasks", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/tasks/new" }.should route_to(:controller => "tasks", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/tasks/1" }.should route_to(:controller => "tasks", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/tasks/1/edit" }.should route_to(:controller => "tasks", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/tasks" }.should route_to(:controller => "tasks", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/tasks/1" }.should route_to(:controller => "tasks", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/tasks/1" }.should route_to(:controller => "tasks", :action => "destroy", :id => "1")
    end
    
    it "#terminate_all_instances" do
      { :post => "/tasks/1/terminate_all_instances" }.should route_to(:controller => "tasks", :action => "terminate_all_instances", :id => "1")
    end
    
    it "#terminate_instance" do
      { :post => "/tasks/1/terminate_instance?instance_id=i-123456" }.should route_to(:controller => "tasks", :action => "terminate_instance", :id => "1")
    end

  end
end
