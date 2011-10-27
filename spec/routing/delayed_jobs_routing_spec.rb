require "spec_helper"

describe DelayedJobsController do
  describe "routing" do

    it "routes to #index" do
      get("/admin/delayed_jobs").should route_to("delayed_jobs#index")
    end

    # it "routes to #new" do
    #   get("/delayed_jobs/new").should route_to("delayed_jobs#new")
    # end

    it "routes to #show" do
      get("/admin/delayed_jobs/1").should route_to("delayed_jobs#show", :id => "1")
    end

    # it "routes to #edit" do
    #   get("/delayed_jobs/1/edit").should route_to("delayed_jobs#edit", :id => "1")
    # end

    # it "routes to #create" do
    #   post("/delayed_jobs").should route_to("delayed_jobs#create")
    # end

    # it "routes to #update" do
    #   put("/delayed_jobs/1").should route_to("delayed_jobs#update", :id => "1")
    # end

    it "routes to #destroy" do
      delete("/admin/delayed_jobs/1").should route_to("delayed_jobs#destroy", :id => "1")
    end
    

  end
end
