require 'spec_helper'

describe "algorithm_binaries/edit.html.erb" do
  
  before(:each) do
    @algorithm = assign(:algorithm, stub_model(Algorithm, :name => "Test alg"))
    @algorithm_binary = assign(:algorithm_binary, stub_model(AlgorithmBinary,
      :algorithm_id => 1,
      :algorithm => @algorithm,
      :description => "MyText",
      :version => "MyString",
      :state => "MyString",
      :launch_params => "MyString"
    ))
  end

  it "renders the edit algorithm_binary form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    # assert_select "form", :action => algorithm_binaries_path(@algorithm_binary), :method => "post" do
    assert_select "form", :action => algorithm_algorithm_binaries_path(@algorithm, @algorithm_binary), :method => "post" do
      # assert_select "input#algorithm_binary_algorithm_id", :name => "algorithm_binary[algorithm_id]"
      assert_select "textarea#algorithm_binary_description", :name => "algorithm_binary[description]"
      assert_select "input#algorithm_binary_version", :name => "algorithm_binary[version]"
      assert_select "select#algorithm_binary_state", :name => "algorithm_binary[state]"
      assert_select "input#algorithm_binary_launch_params", :name => "algorithm_binary[launch_params]"
    end
  end
end
