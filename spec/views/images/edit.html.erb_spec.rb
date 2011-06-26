require 'spec_helper'

describe "images/edit.html.erb" do
  before(:each) do
    @cloud_engine = assign(:cloud_engine, stub_model(CloudEngine).as_null_object)
    @image = assign(:image, stub_model(Image, 
           :cloud_engine => @cloud_engine
    ).as_new_record)
  end
  
  it "renders the edit image form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => [@cloud_engine, @image], :method => "post" do
    end
  end
end
