require 'spec_helper'

describe AlgorithmsController do
  fixtures :users, :algorithms

  let(:user) { users(:test_user1) }
  
  before(:each) do
    sign_in user
  end

  def mock_algorithm(stubs={})
    @mock_algorithm ||= mock_model(Algorithm, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all algorithms as @algorithms" do
      # Algorithm.stub(:all) { [mock_algorithm(:user_id => 1)] }
      get :index
      assigns(:algorithms).should eq([algorithms(:algorithm_1)])
    end
  end

  describe "GET show" do
    it "assigns the requested algorithm as @algorithm" do
      Algorithm.stub(:find).with("37") { mock_algorithm }
      get :show, :id => "37"
      assigns(:algorithm).should be(mock_algorithm)
    end
  end

  describe "GET new" do
    it "assigns a new algorithm as @algorithm" do
      Algorithm.stub(:new) { mock_algorithm }
      get :new
      assigns(:algorithm).should be(mock_algorithm)
    end
  end

  describe "GET edit" do
    it "assigns the requested algorithm as @algorithm" do
      Algorithm.stub(:find).with("37") { mock_algorithm }
      get :edit, :id => "37"
      assigns(:algorithm).should be(mock_algorithm)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created algorithm as @algorithm" do
        Algorithm.stub(:new).with({'these' => 'params'}) { mock_algorithm(:save => true) }
        post :create, :algorithm => {'these' => 'params'}
        assigns(:algorithm).should be(mock_algorithm)
      end

      it "redirects to the created algorithm" do
        Algorithm.stub(:new) { mock_algorithm(:save => true) }
        post :create, :algorithm => {}
        response.should redirect_to(algorithm_url(mock_algorithm))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved algorithm as @algorithm" do
        Algorithm.stub(:new).with({'these' => 'params'}) { mock_algorithm(:save => false) }
        post :create, :algorithm => {'these' => 'params'}
        assigns(:algorithm).should be(mock_algorithm)
      end

      it "re-renders the 'new' template" do
        Algorithm.stub(:new) { mock_algorithm(:save => false) }
        post :create, :algorithm => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested algorithm" do
        Algorithm.stub(:find).with("37") { mock_algorithm }
        mock_algorithm.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :algorithm => {'these' => 'params'}
      end

      it "assigns the requested algorithm as @algorithm" do
        Algorithm.stub(:find) { mock_algorithm(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:algorithm).should be(mock_algorithm)
      end

      it "redirects to the algorithm" do
        Algorithm.stub(:find) { mock_algorithm(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(algorithm_url(mock_algorithm))
      end
    end

    describe "with invalid params" do
      it "assigns the algorithm as @algorithm" do
        Algorithm.stub(:find) { mock_algorithm(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:algorithm).should be(mock_algorithm)
      end

      it "re-renders the 'edit' template" do
        Algorithm.stub(:find) { mock_algorithm(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested algorithm" do
      Algorithm.stub(:find).with("37") { mock_algorithm }
      mock_algorithm.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the algorithms list" do
      Algorithm.stub(:find) { mock_algorithm }
      delete :destroy, :id => "1"
      response.should redirect_to(algorithms_url)
    end
  end

end
