require "spec_helper"

describe AlgorithmBinariesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/algorithm_binaries" }.should route_to(:controller => "algorithm_binaries", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/algorithm_binaries/new" }.should route_to(:controller => "algorithm_binaries", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/algorithm_binaries/1" }.should route_to(:controller => "algorithm_binaries", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/algorithm_binaries/1/edit" }.should route_to(:controller => "algorithm_binaries", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/algorithm_binaries" }.should route_to(:controller => "algorithm_binaries", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/algorithm_binaries/1" }.should route_to(:controller => "algorithm_binaries", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/algorithm_binaries/1" }.should route_to(:controller => "algorithm_binaries", :action => "destroy", :id => "1")
    end

  end
end
