require 'spec_helper'

describe Daemons::OutputsWorkerCtl do
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

  pending
end

