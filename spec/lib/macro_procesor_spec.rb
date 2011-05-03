require 'spec_helper'

describe MacroProcesor do
  describe "regexp for macros" do
    let(:regexp) { MacroProcesor::MACRO_REGEXP }
    
    it "matches everything inside curly braces" do
      "{{LOREM}}".split(regexp).should include("LOREM")
    end
    
    it "matches whole text with spaces" do
      "{{Lorem ipsum dolor sit amet}}".split(regexp).should include("Lorem ipsum dolor sit amet")
    end
    
  end
  
  describe "process_macros method" do
    let(:mock_context) { double("context") }
    
    it "should replace {{BINARY}} macro" do
      mock_context.stub(:algorithm_binary).and_return(true)
      mock_context.stub_chain(:algorithm_binary, :attachment, :data_file_name).and_return("file")
    
      out = MacroProcesor.process_macros("Lorem ipsum {{BINARY}} dolor sit amet.", mock_context)
      out.should_not match("{{BINARY}}")
      out.should match("file")
    end

    it "should replace {{INPUTS}} macro" do
      mock_context.stub(:inputs).and_return("inputs")
    
      out = MacroProcesor.process_macros("Lorem ipsum {{INPUTS}} dolor sit amet.", mock_context)
      out.should_not match("{{INPUTS}}")
      out.should match("inputs")
    end

  end
end