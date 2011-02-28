require 'spec_helper'

describe "algorithm_binaries/new.html.erb" do
  before(:each) do
    assign(:algorithm_binary, stub_model(AlgorithmBinary,
      :algorithm_id => 1,
      :name => "MyString",
      :description => "MyText",
      :version => "MyString",
      :state => "MyString",
      :launch_params => "MyString"
    ).as_new_record)
  end

  it "renders new algorithm_binary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => algorithm_binaries_path, :method => "post" do
      assert_select "input#algorithm_binary_algorithm_id", :name => "algorithm_binary[algorithm_id]"
      assert_select "input#algorithm_binary_name", :name => "algorithm_binary[name]"
      assert_select "textarea#algorithm_binary_description", :name => "algorithm_binary[description]"
      assert_select "input#algorithm_binary_version", :name => "algorithm_binary[version]"
      assert_select "input#algorithm_binary_state", :name => "algorithm_binary[state]"
      assert_select "input#algorithm_binary_launch_params", :name => "algorithm_binary[launch_params]"
    end
  end
end
