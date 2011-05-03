require 'spec_helper'

describe RegistrationsController do
  describe "routing" do
    it "recognizes and generates #new" do
      { :get => "/account/sign_up" }.should route_to(:controller => "registrations", :action => "new")
    end

    it "recognizes and generates #create" do
      { :post => "/account" }.should route_to(:controller => "registrations", :action => "create")
    end

    it "recognizes and generates #edit" do
      { :get => "/account/edit" }.should route_to(:controller => "registrations", :action => "edit")
    end

    it "recognizes and generates #update" do
      { :put => "/account" }.should route_to(:controller => "registrations", :action => "update")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/account" }.should route_to(:controller => "registrations", :action => "destroy")
    end

    it "recognizes and generates #cancel" do
      { :get => "/account/cancel" }.should route_to(:controller => "registrations", :action => "cancel")
    end
  end
end