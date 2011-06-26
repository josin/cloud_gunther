require 'spec_helper'

describe "algorithms/edit.html.erb" do
  before(:each) do
    @algorithm = assign(:algorithm, stub_model(Algorithm,
      :name => "MyString",
      :group => "MyString",
      :author_id => 1,
      :description => "MyString",
      :launch_params => "MyString"
    ))
  end
  
  it "renders the edit algorithm form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => algorithms_path(@algorithm), :method => "post" do
      # assert_select "input#algorithm_name", :name => "algorithm[name]"
      # assert_select "input#algorithm_group", :name => "algorithm[group]"
      # assert_select "input#algorithm_author_id", :name => "algorithm[author_id]"
      # assert_select "input#algorithm_description", :name => "algorithm[description]"
      # assert_select "input#algorithm_launch_params", :name => "algorithm[launch_params]"
    end
  end
end
