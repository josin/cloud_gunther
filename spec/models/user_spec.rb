require 'spec_helper'

describe User do
  let(:user) { mock_model(User, :first_name => "John", :last_name => "Doe", :email => "john.doe@fel.cvut.cz")}
  
  it "new created user should have generated auth_token" do
    user = User.new
    user.should_receive(:reset_authentication_token!)
    # user.run_callbacks(:before_create)
    user.send(:action_before_create)
  end
  
end
