require 'spec_helper'

describe RegistrationsController do
  fixtures :users

  let(:user) { users(:test_user1) }
  let(:mock_user) { mock_model(User) }
  
  describe "GET new" do
    it "renders form for registrating a new user" do
      pending
      User.stub(:new) { mock_user }
      get :new
      # assigns(:algorithm).should be(mock_user)
    end
  end
  
  describe "POST create" do
  end

  describe "GET edit" do
    before(:each) do
      sign_in user
    end
  end
  
  
  describe "PUT update" do
    before(:each) do
      sign_in user
    end
  end

end
