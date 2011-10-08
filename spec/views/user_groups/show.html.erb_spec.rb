require 'spec_helper'

describe "user_groups/show.html.erb" do
  before(:each) do
    @user_group = assign(:user_group, stub_model(UserGroup))
  end

  it "renders attributes in <p>" do
    render
  end
end
