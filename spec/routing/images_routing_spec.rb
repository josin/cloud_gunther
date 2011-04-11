require "spec_helper"

describe ImagesController do
  before(:each) do
    @base_path = "/admin/cloud_engines/1"
    @base_route = { :cloud_engine_id => "1", :controller => "images" }
  end
  
  
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "#{@base_path}/images" }.should route_to(@base_route.merge(:action => "index"))
    end

    it "recognizes and generates #new" do
      { :get => "#{@base_path}/images/new" }.should route_to(@base_route.merge(:action => "new"))
    end

    it "recognizes and generates #show" do
      { :get => "#{@base_path}/images/1" }.should route_to(@base_route.merge(:action => "show", :id => "1"))
    end

    it "recognizes and generates #edit" do
      { :get => "#{@base_path}/images/1/edit" }.should route_to(@base_route.merge(:action => "edit", :id => "1"))
    end

    it "recognizes and generates #create" do
      { :post => "#{@base_path}/images" }.should route_to(@base_route.merge(:action => "create"))
    end

    it "recognizes and generates #update" do
      { :put => "#{@base_path}/images/1" }.should route_to(@base_route.merge(:action => "update", :id => "1"))
    end

    it "recognizes and generates #destroy" do
      { :delete => "#{@base_path}/images/1" }.should route_to(@base_route.merge(:action => "destroy", :id => "1"))
    end

  end
end
