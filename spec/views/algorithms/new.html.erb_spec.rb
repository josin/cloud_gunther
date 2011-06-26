require 'spec_helper'

describe "algorithms/new.html.erb" do
  before(:each) do
    assign(:algorithm, stub_model(Algorithm,
      :name => "MyString",
      :group => "MyString",
      :author_id => 1,
      :description => "MyString",
      :launch_params => "MyString"
    ).as_new_record)
  end
  
  it "renders new algorithm form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => algorithms_path, :method => "post" do
      # assert_select "input#algorithm_name", :name => "algorithm[name]"
      # assert_select "input#algorithm_group", :name => "algorithm[group]"
      # assert_select "input#algorithm_author_id", :name => "algorithm[author_id]"
      # assert_select "input#algorithm_description", :name => "algorithm[description]"
      # assert_select "input#algorithm_launch_params", :name => "algorithm[launch_params]"
    end
  end
end
