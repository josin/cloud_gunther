require 'spec_helper'

describe Daemons::OutputsWorker do
  let(:msg) { <<-EOF
<?xml version="1.0" encoding="UTF-8"?>
<output>
  <task-id>1</task-id>
  <stdout>It works!</stdout>
  <stderr>File not found.</stderr>
  <params>
    <instance-id>i-123456</instance-id>
  </params>
</output>
EOF
}
  let(:bunny) { mock("bunny", :start => "connected") }
  let(:queue) { mock("queue", :publish => true) }
  let(:connection) { mock("connection") }

  describe "run method" do
    pending
    # it "runs outputs worker job" do
    #   Bunny.should_receive(:new).and_return(bunny)
    #   bunny.should_receive(:queue).with("outputs").and_return(queue)
    #   
    #   queue.should_receive(:pop).and_return({:payload => msg})
    #   queue.should_receive(:pop).and_return(:queue_empty)
    #   
    #   Daemons::OutputsWorker.run
    # end
  end
end

