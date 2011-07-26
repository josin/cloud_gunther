require 'spec_helper'

describe "users/index.html.erb" do
  before(:each) do
    assign(:search, User.metasearch)
    @users = assign(:users, [
      stub_model(User,
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :unix_uid => 1000,
        :unix_username => "foo"
      ),
      stub_model(User,
        :first_name => "First Name",
        :last_name => "Last Name",
        :email => "Email",
        :unix_uid => 1001,
        :unix_username => "bar"
      )
    ])
    @users.stub!(:total_pages).and_return(1)
  end

  it "renders a list of users" do
    render

    assert_select "tbody > tr", :count => 2
  end
end
