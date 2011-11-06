require 'spec_helper'

describe ParamsReader do
  
  class DummyClass
    attr_accessor :params
    include ParamsReader
  end
  
  let(:context) { DummyClass.new }
  
  it "empty string when params not defined" do
    context.params = nil
    context.send(:read_from_params, :params, :bar).should be_empty
  end

  it "returns value empty string even if params field doesn't exist" do
    context.send(:read_from_params, :foo, :bar).should be_empty
  end

  it "returns value for specified key in params field" do
    context.params = { :foo => "bar" }
    context.send(:read_from_params, :params, :foo).should eq("bar")
  end

end