require 'spec_helper'

describe "images/edit.html.erb" do
  before(:each) do
    @cloud_engine = assign(:cloud_engine, stub_model(CloudEngine).as_null_object)
    @image = assign(:image, stub_model(Image, 
      :cloud_engine => @cloud_engine,
      :title => "Foobar image",
      :description => "Lorem ipsum dolor sit amet, consectetur adipisicing elit.",
      :cloud_engine_id => 1,
      :launch_params => {:image_id => "emi-123456"},
      :start_up_script => "whoami"
    ).as_new_record)
  end
  
  it "renders the edit image form" do
    render
  
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => [@cloud_engine, @image], :method => "post" do
    end
  end
end
