require 'spec_helper'

describe UserGroupAssoc do
  
  let(:user_group_assoc) { UserGroupAssoc.new }
  
  it "describes associations" do
    user_group_assoc.respond_to?(:user).should be_true
    user_group_assoc.respond_to?(:user_group).should be_true
  end
end
