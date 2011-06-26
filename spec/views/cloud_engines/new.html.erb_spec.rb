require 'spec_helper'

describe "cloud_engines/new.html.erb" do
  before(:each) do
    assign(:cloud_engine, stub_model(CloudEngine).as_new_record)
  end
  
  it "renders new cloud_engine form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => cloud_engines_path, :method => "post" do
    end
  end
end
