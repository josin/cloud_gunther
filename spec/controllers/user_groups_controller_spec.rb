require 'spec_helper'

describe UserGroupsController do
  fixtures :users, :user_groups
  
  let(:user) { users(:test_user1) }
  
  before(:each) do
    sign_in user
  end

  # This should return the minimal set of attributes required to create a valid
  # UserGroup. As you add validations to UserGroup, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :name => "students", :priority => 1 }
  end

  describe "GET index" do
    it "assigns all user_groups as @user_groups" do
      user_group = UserGroup.create! valid_attributes
      get :index
      assigns(:user_groups).should eq([user_group.reload])
    end
  end

  describe "GET show" do
    it "assigns the requested user_group as @user_group" do
      user_group = UserGroup.create! valid_attributes
      get :show, :id => user_group.id.to_s
      assigns(:user_group).should eq(user_group)
    end
  end

  describe "GET new" do
    it "assigns a new user_group as @user_group" do
      get :new
      assigns(:user_group).should be_a_new(UserGroup)
    end
  end

  describe "GET edit" do
    it "assigns the requested user_group as @user_group" do
      user_group = UserGroup.create! valid_attributes
      get :edit, :id => user_group.id.to_s
      assigns(:user_group).should eq(user_group)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new UserGroup" do
        expect {
          post :create, :user_group => valid_attributes
        }.to change(UserGroup, :count).by(1)
      end

      it "assigns a newly created user_group as @user_group" do
        post :create, :user_group => valid_attributes
        assigns(:user_group).should be_a(UserGroup)
        assigns(:user_group).should be_persisted
      end

      it "redirects to the created user_group" do
        post :create, :user_group => valid_attributes
        response.should redirect_to(UserGroup.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user_group as @user_group" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserGroup.any_instance.stub(:save).and_return(false)
        post :create, :user_group => {}
        assigns(:user_group).should be_a_new(UserGroup)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        UserGroup.any_instance.stub(:save).and_return(false)
        post :create, :user_group => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user_group" do
        user_group = UserGroup.create! valid_attributes
        # Assuming there are no other user_groups in the database, this
        # specifies that the UserGroup created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        UserGroup.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => user_group.id, :user_group => {'these' => 'params'}
      end

      it "assigns the requested user_group as @user_group" do
        user_group = UserGroup.create! valid_attributes
        put :update, :id => user_group.id, :user_group => valid_attributes
        assigns(:user_group).should eq(user_group)
      end

      it "redirects to the user_group" do
        user_group = UserGroup.create! valid_attributes
        put :update, :id => user_group.id, :user_group => valid_attributes
        response.should redirect_to(user_group)
      end
    end

    describe "with invalid params" do
      it "assigns the user_group as @user_group" do
        user_group = UserGroup.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        UserGroup.any_instance.stub(:save).and_return(false)
        put :update, :id => user_group.id.to_s, :user_group => {}
        assigns(:user_group).should eq(user_group)
      end

      it "re-renders the 'edit' template" do
        user_group = UserGroup.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        UserGroup.any_instance.stub(:save).and_return(false)
        put :update, :id => user_group.id.to_s, :user_group => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user_group" do
      user_group = UserGroup.create! valid_attributes
      expect {
        delete :destroy, :id => user_group.id.to_s
      }.to change(UserGroup, :count).by(-1)
    end

    it "redirects to the user_groups list" do
      user_group = UserGroup.create! valid_attributes
      delete :destroy, :id => user_group.id.to_s
      response.should redirect_to(user_groups_url)
    end
  end

end
