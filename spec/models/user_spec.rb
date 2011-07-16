require 'spec_helper'

describe User do
  let(:user) { mock_model(User, :first_name => "John", :last_name => "Doe", :email => "john.doe@fel.cvut.cz").as_null_object }

  describe "callbacs" do
    it "new user should be locked" do
      user = User.new
      user.send(:action_before_create)
    
      user.state.should eq("new")
      user.locked_at.should_not be_nil
    end
  
    it "user should have authentication token" do
      user = User.new
      user.should_receive(:reset_authentication_token!)
      user.send(:action_before_save)
    end
  end
end
