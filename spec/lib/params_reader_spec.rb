require 'spec_helper'

describe ParamsReader do
  
  class DummyClass
    attr_accessor :params

    include ParamsReader
    def foo; read_from_params(:params, :foo); end
  end
  
  let(:context) { DummyClass.new }
  
  it "empty string when params not defined" do
    context.params = nil
    context.foo.should be_empty
  end

  it "returns value empty string even if params field doesn't exist" do
    context.foo.should be_empty
  end

  # it "returns value for specified key in params field - symbol key" do
  #   context.params = { :foo => "bar" }
  #   context.foo.should eq("bar")
  # end
  
  it "returns value for specified key in params field - string key" do
    context.params = { "foo" => "bar" }
    context.foo.should eq("bar")
  end

end