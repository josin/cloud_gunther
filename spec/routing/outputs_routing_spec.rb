require "spec_helper"

describe OutputsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/outputs" }.should route_to(:controller => "outputs", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/outputs/new" }.should route_to(:controller => "outputs", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/outputs/1" }.should route_to(:controller => "outputs", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/outputs/1/edit" }.should route_to(:controller => "outputs", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/outputs" }.should route_to(:controller => "outputs", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/outputs/1" }.should route_to(:controller => "outputs", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/outputs/1" }.should route_to(:controller => "outputs", :action => "destroy", :id => "1")
    end

  end
end
