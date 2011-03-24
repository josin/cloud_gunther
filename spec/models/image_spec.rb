require 'spec_helper'

describe Image do
  # pending "add some examples to (or delete) #{__FILE__}"
  
  before(:each) do
    # image = mock_model(Image)
    Image.stub(:action_before_save).and_return(nil)
    # mock_model(Image).stub(:action_before_save).and_return(nil)
  end
  
  it "does something" do
    image = Image.new()
    # image.action_before_save
    image.save
  end
  
  
end
