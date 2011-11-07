require "spec_helper"

describe CloudEnginesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin/cloud_engines" }.should route_to(:controller => "cloud_engines", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin/cloud_engines/new" }.should route_to(:controller => "cloud_engines", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin/cloud_engines/1" }.should route_to(:controller => "cloud_engines", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin/cloud_engines/1/edit" }.should route_to(:controller => "cloud_engines", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin/cloud_engines" }.should route_to(:controller => "cloud_engines", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin/cloud_engines/1" }.should route_to(:controller => "cloud_engines", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin/cloud_engines/1" }.should route_to(:controller => "cloud_engines", :action => "destroy", :id => "1")
    end
    
    it "#availability_zones_info" do
      { :get => "/admin/cloud_engines/1/availability_zones_info" }.should route_to(:controller => "cloud_engines", :action => "availability_zones_info", :id => "1")
    end
    
    it "#availability_zones" do
      { :get => "/admin/cloud_engines/1/availability_zones" }.should route_to(:controller => "cloud_engines", :action => "availability_zones", :id => "1")
    end

  end
end
