require 'spec_helper'

describe "delayed_jobs/index.html.erb" do
  before(:each) do
    assign(:delayed_jobs, [
      stub_model(DelayedJob),
      stub_model(DelayedJob)
    ])
  end

  it "renders a list of delayed_jobs" do
    render
  end
end
