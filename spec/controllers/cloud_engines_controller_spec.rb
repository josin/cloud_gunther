require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe CloudEnginesController do

  def mock_cloud_engine(stubs={})
    @mock_cloud_engine ||= mock_model(CloudEngine, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all cloud_engines as @cloud_engines" do
      CloudEngine.stub(:all) { [mock_cloud_engine] }
      get :index
      assigns(:cloud_engines).should eq([mock_cloud_engine])
    end
  end

  describe "GET show" do
    it "assigns the requested cloud_engine as @cloud_engine" do
      CloudEngine.stub(:find).with("37") { mock_cloud_engine }
      get :show, :id => "37"
      assigns(:cloud_engine).should be(mock_cloud_engine)
    end
  end

  describe "GET new" do
    it "assigns a new cloud_engine as @cloud_engine" do
      CloudEngine.stub(:new) { mock_cloud_engine }
      get :new
      assigns(:cloud_engine).should be(mock_cloud_engine)
    end
  end

  describe "GET edit" do
    it "assigns the requested cloud_engine as @cloud_engine" do
      CloudEngine.stub(:find).with("37") { mock_cloud_engine }
      get :edit, :id => "37"
      assigns(:cloud_engine).should be(mock_cloud_engine)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created cloud_engine as @cloud_engine" do
        CloudEngine.stub(:new).with({'these' => 'params'}) { mock_cloud_engine(:save => true) }
        post :create, :cloud_engine => {'these' => 'params'}
        assigns(:cloud_engine).should be(mock_cloud_engine)
      end

      it "redirects to the created cloud_engine" do
        CloudEngine.stub(:new) { mock_cloud_engine(:save => true) }
        post :create, :cloud_engine => {}
        response.should redirect_to(cloud_engine_url(mock_cloud_engine))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved cloud_engine as @cloud_engine" do
        CloudEngine.stub(:new).with({'these' => 'params'}) { mock_cloud_engine(:save => false) }
        post :create, :cloud_engine => {'these' => 'params'}
        assigns(:cloud_engine).should be(mock_cloud_engine)
      end

      it "re-renders the 'new' template" do
        CloudEngine.stub(:new) { mock_cloud_engine(:save => false) }
        post :create, :cloud_engine => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested cloud_engine" do
        CloudEngine.stub(:find).with("37") { mock_cloud_engine }
        mock_cloud_engine.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :cloud_engine => {'these' => 'params'}
      end

      it "assigns the requested cloud_engine as @cloud_engine" do
        CloudEngine.stub(:find) { mock_cloud_engine(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:cloud_engine).should be(mock_cloud_engine)
      end

      it "redirects to the cloud_engine" do
        CloudEngine.stub(:find) { mock_cloud_engine(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(cloud_engine_url(mock_cloud_engine))
      end
    end

    describe "with invalid params" do
      it "assigns the cloud_engine as @cloud_engine" do
        CloudEngine.stub(:find) { mock_cloud_engine(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:cloud_engine).should be(mock_cloud_engine)
      end

      it "re-renders the 'edit' template" do
        CloudEngine.stub(:find) { mock_cloud_engine(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested cloud_engine" do
      CloudEngine.stub(:find).with("37") { mock_cloud_engine }
      mock_cloud_engine.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the cloud_engines list" do
      CloudEngine.stub(:find) { mock_cloud_engine }
      delete :destroy, :id => "1"
      response.should redirect_to(cloud_engines_url)
    end
  end

end
