require 'spec_helper'

describe Image do
  let(:image) { Image.new }
  let(:launch_params) { {"image_id" => "emi-123456"} }
  let(:task) { mock_model(Task).as_null_object }
  
  it "should return image description from server" do
    image.stub(:launch_params => launch_params)
    image.launch_params[:image_id].should == launch_params[:image_id]
    
    mock_connection = mock("connection")
    mock_connection.stub(:ec2_describe_images).with("ImageId" => "emi-123456").and_return([{:image => "description"}])
    
    image.stub_chain(:cloud_engine, :connect!).and_return(mock_connection)
    image.describe_image!.should == {:image => "description"}
  end
  
  describe "start up script for ssh" do
    it "returns single line start up script" do
      image.start_up_script = "useradd -o -u 1004 euca"
      image.start_up_script_for_ssh(task).should eq("useradd -o -u 1004 euca")
    end
    
    it "returns multiline start up script divided with semicolons" do
      image.start_up_script = <<-SCR
which /usr/bin/ruby

touch /tmp/cloud_gunther.txt
SCR

      image.start_up_script_for_ssh(task).should eq("which /usr/bin/ruby;touch /tmp/cloud_gunther.txt")
    end
    
    it "returns script with succesfully processed macros" do
      task.stub_chain(:user, :unix_uid).and_return("1000")
      
      image.start_up_script = "useradd -o -u {{UNIX_UID}} {{CLOUD_USER}}"
      image.start_up_script_for_ssh(task).should eq("useradd -o -u 1000 euca")
    end
    
    it "returns correct start-up-script from webapp textarea" do
      task.stub_chain(:user, :unix_uid).and_return("1000")
      
      image.start_up_script = "useradd -o -u {{UNIX_UID}} {{CLOUD_USER}}\r\necho `date` >> /tmp/cloud_gunther.txt"
      image.start_up_script_for_ssh(task).should eq("useradd -o -u 1000 euca;echo `date` >> /tmp/cloud_gunther.txt")
    end
  end
  
end
