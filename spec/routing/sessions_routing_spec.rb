require 'spec_helper'

describe SessionsController do
  describe "routing" do
    it "recognizes and generates #new" do
      { :get => "/account/sign_in" }.should route_to(:controller => "sessions", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/account/sign_in" }.should route_to(:controller => "sessions", :action => "create")
    end

    it "recognizes and generates #destroy" do
      { :get => "/account/sign_out" }.should route_to(:controller => "sessions", :action => "destroy")
    end
  end
end