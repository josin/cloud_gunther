require 'spec_helper'

describe VerboseAvailabilityZonesInfo do
  
  SAMPLE_INPUT = <<-EOF
AVAILABILITYZONE	stud2	147.32.84.118
AVAILABILITYZONE	|- vm types	free / max   cpu   ram  disk
AVAILABILITYZONE	|- m1.small	0000 / 0000   1    320     4
AVAILABILITYZONE	|- c1.medium	0000 / 0000   1    853     8
AVAILABILITYZONE	|- m1.large	0000 / 0000   1   1280    16
AVAILABILITYZONE	|- m1.xlarge	0000 / 0000   2   2048    16
AVAILABILITYZONE	|- c1.xlarge	0000 / 0000   2   2560    32
AVAILABILITYZONE	ucebny	147.32.84.129
AVAILABILITYZONE	|- vm types	free / max   cpu   ram  disk
AVAILABILITYZONE	|- m1.small	0000 / 0000   1    320     4
AVAILABILITYZONE	|- c1.medium	0000 / 0000   1    853     8
AVAILABILITYZONE	|- m1.large	0000 / 0000   1   1280    16
AVAILABILITYZONE	|- m1.xlarge	0000 / 0000   2   2048    16
AVAILABILITYZONE	|- c1.xlarge	0000 / 0000   2   2560    32
EOF

  # SAMPLE_OUTPUT = [{:zone_name=>"stud2", :zone_state=>"147.32.84.118"}, {:zone_name=>"ucebny", :zone_state=>"147.32.84.129"}]
  
  it "should return verbose availability zones info" do
    pending
  #   VerboseAvailabilityZonesInfo::OutputParser.should_receive(:parse).with(SAMPLE_INPUT)
  #   VerboseAvailabilityZonesInfo.get_info(cmd)
  end

  describe VerboseAvailabilityZonesInfo::OutputParser do
    let(:parser) { VerboseAvailabilityZonesInfo::OutputParser }
  
    it "should parse given input into array of hashes" do
      output = parser.parse(SAMPLE_INPUT)
      output.should be_an(Array)
      output.should have(2).items
      output.first.should include(:zone_name, :zone_state, :resources)
    end
    
    it "parse zone description" do
      parser.send(:parse_description, "AVAILABILITYZONE	stud2	147.32.84.118").should eq({:zone_name => "stud2", :zone_state => "147.32.84.118"})
    end
    
    it "parse resource description body" do
      res = parser.send(:parse_resource_description_body_line, "AVAILABILITYZONE	|- c1.xlarge	0000 / 0000   2   2560    32")
      res.should include("c1.xlarge")
      res["c1.xlarge"].should include(:free, :max, :cpu, :ram, :disk)
      res["c1.xlarge"].each { |key, value| value.should_not be_empty }
    end
    
  end
end

