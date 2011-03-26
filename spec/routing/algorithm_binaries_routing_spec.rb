require "spec_helper"

describe AlgorithmBinariesController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/algorithms/1/binaries" }.should route_to(:controller => "algorithm_binaries", :action => "index", :algorithm_id => "1")
    end

    it "recognizes and generates #new" do
      { :get => "/algorithms/1/binaries/new" }.should route_to(:controller => "algorithm_binaries", :action => "new", :algorithm_id => "1")
    end

    it "recognizes and generates #show" do
      { :get => "/algorithms/1/binaries/1" }.should route_to(:controller => "algorithm_binaries", :action => "show", :id => "1", :algorithm_id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/algorithms/1/binaries/1/edit" }.should route_to(:controller => "algorithm_binaries", :action => "edit", :id => "1", :algorithm_id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/algorithms/1/binaries" }.should route_to(:controller => "algorithm_binaries", :action => "create", :algorithm_id => "1")
    end

    it "recognizes and generates #update" do
      { :put => "/algorithms/1/binaries/1" }.should route_to(:controller => "algorithm_binaries", :action => "update", :id => "1", :algorithm_id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/algorithms/1/binaries/1" }.should route_to(:controller => "algorithm_binaries", :action => "destroy", :id => "1", :algorithm_id => "1")
    end

  end
end
