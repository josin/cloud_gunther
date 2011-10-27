require 'spec_helper'

describe "delayed_jobs/show.html.erb" do
  before(:each) do
    @delayed_job = assign(:delayed_job, stub_model(DelayedJob))
  end

  it "renders attributes in <p>" do
    render
  end
end
