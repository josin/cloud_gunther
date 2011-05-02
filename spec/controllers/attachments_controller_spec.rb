require 'spec_helper'

describe AttachmentsController do
  fixtures :users
  
  let(:user) { users(:test_user1) }
  
  before(:each) do
    sign_in user
  end
  
  def mock_attachment(stubs={})
    @mock_attachment ||= mock_model(Attachment, stubs).as_null_object
  end

  describe "GET show" do
    it "assigns the requested attachment as @attachment" do
      Attachment.stub(:find).with("37") { mock_attachment }
      controller.should_receive(:send_file)
      controller.stub!(:render)
      get :show, :id => "37"
      assigns(:attachment).should be(mock_attachment)
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      controller.stub!(:respond_to)
      controller.stub!(:render)
    end
    
    it "destroys the requested attachment" do
      Attachment.stub(:find).with("37") { mock_attachment }
      mock_attachment.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  end
  
end
