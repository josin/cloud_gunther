require 'spec_helper'

describe User do
  let(:user) { mock_model(User, :first_name => "John", :last_name => "Doe", :email => "john.doe@fel.cvut.cz", :priority => 5).as_null_object }
  
  describe "callbacs" do
    it "new user should be locked" do
      user = User.new
      user.send(:action_before_create)
    
      user.state.should eq("new")
      user.locked_at.should_not be_nil
    end
    
    it "user should have authentication token" do
      user = User.new
      user.should_receive(:reset_authentication_token!)
      user.send(:action_before_save)
    end
  end
  
  describe "user priority" do
    let(:user) { User.new(:priority => 1) }
    let(:grp1) { UserGroup.new(:name => "Grp 1", :priority => 2) }
    let(:grp2) { UserGroup.new(:name => "Grp 2", :priority => 3) }
    
    before(:each) do
      user.user_groups << grp1
      user.user_groups << grp2
    end
    
    it "should return user's priority" do
      user.priority.should be_an(Integer)
      user.priority.should eq(1)
    end
    
    it "user should have assigned some user groups" do
      user.user_groups.should have_at_least(1).groups
    end
    
    describe "real priority" do
      it "returns users real priority based on user groups and self priority" do
        user.real_priority.should eq(3)
      end
      
      it "should return users self priority" do
        user.priority = 10
        user.real_priority.should eq(10)
      end
      
      it "should not raise exception when user priority is nil" do
        user.priority = nil
        expect { user.real_priority.should_not be_nil }.to_not raise_exception
      end
    end
  end
end
