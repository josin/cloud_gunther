require 'spec_helper'

describe "algorithm_binaries/show.html.erb" do
  before(:each) do
    @algorithm_binary = assign(:algorithm_binary, stub_model(AlgorithmBinary,
      :algorithm_id => 1,
      :name => "Name",
      :description => "MyText",
      :version => "Version",
      :state => "State",
      :launch_params => "Launch Params"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/MyText/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Version/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Launch Params/)
  end
end
