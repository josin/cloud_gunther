require "spec_helper"

describe OutputsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/tasks/1/outputs" }.should route_to(:controller => "outputs", :action => "index", :task_id => "1")
    end

    # it "recognizes and generates #new" do
    #   { :get => "/tasks/1/outputs/new" }.should route_to(:controller => "outputs", :action => "new", :task_id => "1")
    # end

    it "recognizes and generates #show" do
      { :get => "/tasks/1/outputs/1" }.should route_to(:controller => "outputs", :action => "show", :id => "1", :task_id => "1")
    end

    # it "recognizes and generates #edit" do
    #   { :get => "/tasks/1/outputs/1/edit" }.should route_to(:controller => "outputs", :action => "edit", :id => "1", :task_id => "1")
    # end

    # it "recognizes and generates #create" do
    #   { :post => "/tasks/1/outputs" }.should route_to(:controller => "outputs", :action => "create", :task_id => "1")
    # end

    # it "recognizes and generates #update" do
    #   { :put => "/tasks/1/outputs/1" }.should route_to(:controller => "outputs", :action => "update", :id => "1", :task_id => "1")
    # end

    it "recognizes and generates #destroy" do
      { :delete => "/tasks/1/outputs/1" }.should route_to(:controller => "outputs", :action => "destroy", :id => "1", :task_id => "1")
    end

  end
end
