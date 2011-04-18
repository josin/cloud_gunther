require 'spec_helper'

describe Image do
  let(:image) { mock_model(Image) }
  let(:launch_params) { {:image_id => "emi-123456"} }
  
  it "should return image description from server" do
    image = Image.new
    image.stub(:launch_params).and_return(launch_params)
    image.launch_params[:image_id].should == launch_params[:image_id]
    
    mock_connection = mock("connection")
    mock_connection.stub(:ec2_describe_images).with("ImageId" => "emi-123456").and_return([{:image => "description"}])
    
    image.stub_chain(:cloud_engine, :connect!).and_return(mock_connection)
    image.describe_image!.should == {:image => "description"}
  end
  
end
