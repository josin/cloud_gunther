require 'spec_helper'

describe UsersController do
  fixtures :users
  
  let(:user) { users(:test_user1) }
  
  before(:each) do
    sign_in user
  end
  
  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all users as users" do
      get :index
      assigns(:users).should eq(User.all)
    end
  end

  describe "GET show" do
    it "assigns the requested user as user" do
      User.stub(:find).with(user.id) { user }
      get :show, :id => user.id
      assigns(:user).should == user
    end
  end

  describe "GET new" do
    it "assigns a new user as user" do
      User.stub(:new) { mock_user }
      get :new
      assigns(:user).should be(mock_user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as user" do
      User.stub(:find).with(user.id) { mock_user }
      get :edit, :id => user.id
      assigns(:user).should be(mock_user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created user as user" do
        User.stub(:new).with({'these' => 'params'}) { mock_user(:save => true) }
        post :create, :user => {'these' => 'params'}
        assigns(:user).should be(mock_user)
      end

      it "redirects to the created user" do
        User.stub(:new) { mock_user(:save => true) }
        post :create, :user => {}
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as user" do
        User.stub(:new).with({'these' => 'params'}) { mock_user(:save => false) }
        post :create, :user => {'these' => 'params'}
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'new' template" do
        User.stub(:new) { mock_user(:save => false) }
        post :create, :user => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        User.stub(:find).with(user.id) { mock_user }
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => user.id, :user => {'these' => 'params'}
      end

      it "assigns the requested user as user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "redirects to the user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as user" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'edit' template" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      User.stub(:find).with(user.id) { mock_user }
      mock_user.should_receive(:destroy)
      delete :destroy, :id => user.id
    end

    it "redirects to the users list" do
      User.stub(:find) { mock_user }
      delete :destroy, :id => "1"
      response.should redirect_to(users_url)
    end
  end

end
