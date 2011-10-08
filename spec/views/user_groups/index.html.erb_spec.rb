require 'spec_helper'

describe "user_groups/index.html.erb" do
  before(:each) do
    assign(:search, UserGroup.metasearch)
    @user_groups = assign(:user_groups, [
      stub_model(UserGroup),
      stub_model(UserGroup)
    ])
    @user_groups.stub!(:total_pages).and_return(1)
  end

  it "renders a list of user_groups" do
    render
    
    assert_select "tbody > tr", :count => 2
  end
end
