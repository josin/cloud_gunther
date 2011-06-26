require 'spec_helper'

describe "cloud_engines/edit.html.erb" do
  before(:each) do
    @cloud_engine = assign(:cloud_engine, stub_model(CloudEngine))
  end
  
  it "renders the edit cloud_engine form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cloud_engines_path(@cloud_engine), :method => "post" do
    end
  end
end
