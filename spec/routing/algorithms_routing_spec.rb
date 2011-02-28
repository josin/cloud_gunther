require "spec_helper"

describe AlgorithmsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/algorithms" }.should route_to(:controller => "algorithms", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/algorithms/new" }.should route_to(:controller => "algorithms", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/algorithms/1" }.should route_to(:controller => "algorithms", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/algorithms/1/edit" }.should route_to(:controller => "algorithms", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/algorithms" }.should route_to(:controller => "algorithms", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/algorithms/1" }.should route_to(:controller => "algorithms", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/algorithms/1" }.should route_to(:controller => "algorithms", :action => "destroy", :id => "1")
    end

  end
end
