require 'spec_helper'

describe "registrations/new.html.erb" do
  let(:user) { stub_model(User).as_new_record }
  
  before(:each) do
    assign(:user, user)
    # Devise provides resource and resource_name helpers and
    # mappings so stub them here.
    @view.stub(:resource).and_return(user)
    @view.stub(:resource_name).and_return('user')
    @view.stub(:resource_class).and_return(user.class)
    @view.stub(:devise_mapping).and_return(Devise.mappings[:user])
    @view.stub(:devise_error_messages!)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => user_registration_path, :method => "post" do
      assert_select "input#user_first_name", :name => "user[first_name]"
      assert_select "input#user_last_name", :name => "user[last_name]"
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_password", :name => "user[password]"
      assert_select "input#user_password_confirmation", :name => "user[password_confirmation]"
      assert_select "input#user_submit", :name => "commit"
    end
  end
end
