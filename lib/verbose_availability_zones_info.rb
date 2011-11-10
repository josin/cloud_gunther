# RightAws doesn't provide interface to fetch zones availablity info with verbose param. First option is to fork
# right_aws gem or write simple parser to parse command from OS. This is the implementation of second choice. For 
# successful run of this module, user must be able to run command 'euca-describe-availability-zones verbose'.
#
# ==== Commmand 
#     euca-describe-availability-zones verbose
# 
# ==== Sample Outputs from euca-describe-availability-zones cmd
# * without verbose param
#   [{:zone_name=>"stud2", :zone_state=>"147.32.84.118"}, {:zone_name=>"ucebny", :zone_state=>"147.32.84.129"}]
# 
# * with verbose param
#   AVAILABILITYZONE  stud2 147.32.84.118
#   AVAILABILITYZONE  |- vm types free / max   cpu   ram  disk
#   AVAILABILITYZONE  |- m1.small 0000 / 0000   1    320     4
#   AVAILABILITYZONE  |- c1.medium  0000 / 0000   1    853     8
#   AVAILABILITYZONE  |- m1.large 0000 / 0000   1   1280    16
#   AVAILABILITYZONE  |- m1.xlarge  0000 / 0000   2   2048    16
#   AVAILABILITYZONE  |- c1.xlarge  0000 / 0000   2   2560    32
# 
module VerboseAvailabilityZonesInfo
  def self.get_info(cmd)
    raise "Availability zones command must be specified in Cloud Engine." if cmd.blank?
    
    stdout, stderr = "", ""
    status = POpen4::popen4(cmd) do |out, err, stdin, pid|
      out.each_line { |line| stdout << line }
      err.each_line { |line| stderr << line }
    end
    
    raise "Error occured when fetching info about availability zones. Error: #{stderr}" unless stderr.blank? 

    VerboseAvailabilityZonesInfo::OutputParser.parse(stdout)
  end
  
  class OutputParser
    
    LINE_BEGINNING = /AVAILABILITYZONE/
    ZONE_DESCRIPTION = /\s*(\S*)\s*(\S*)/
    ZONE_RESOURCE_DESCRIPTION_BODY = /\|-/
    
    class << self
      # ==== Sample output
      # [{
      #    :zone_name => "stud2", 
      #    :zone_state => "147.32.84.118",
      #    :resources => {
      #      "m1.small" => {:free => "0000", :max => "0000", :cpu => 1, :ram => 320, :disk => 4 },
      #      ...
      #    }
      # }]
      def parse(input)
        @output = []
        
        lines =  []
        input.each_line { |line| lines << line }
        do_parse lines
        
        # Rails.logger.debug @output.inspect  
        @output
      end
      
      private
      
      def do_parse(input_arr)
        return if input_arr.blank?

        zone = { 
          :resources => {},
        }
        
        # parse description
        zone.merge! parse_description(input_arr.shift)
        
        # skip resource heading
        input_arr.shift
        
        while !input_arr.empty? and input_arr.first.match(ZONE_RESOURCE_DESCRIPTION_BODY)
          zone[:resources].merge! parse_resource_description_body_line(input_arr.shift)
        end
        
        @output << zone
        
        do_parse input_arr
      end
      
      def parse_description(str)
        matched = str.match /#{LINE_BEGINNING}#{ZONE_DESCRIPTION}/
        { :zone_name => matched[1], :zone_state => matched[2] }
      end
      
      def parse_resource_description_body_line(str)
        matched = str.split(/\s/).select{ |n| n and n =~ /\w/ }
        { "#{matched[1]}" => { :free => matched[2], :max => matched[3], :cpu => matched[4], :ram => matched[5], :disk => matched[6] } }
      end
      
    end # of self class
  end # of class
end # of module