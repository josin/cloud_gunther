require 'spec_helper'

describe "Users" do
  fixtures :users
  
  describe "GET /users" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get users_path, :auth_token => "foobar"
      response.status.should be(200)
    end
  end
end
