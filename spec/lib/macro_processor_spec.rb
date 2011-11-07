require 'spec_helper'

describe MacroProcessor do
  let(:mock_context) { mock_model(Task) }

  describe "regexp for macros" do
    let(:regexp) { MacroProcessor::MACRO_REGEXP }
    
    it "matches everything inside curly braces" do
      "{{LOREM}}".split(regexp).should include("LOREM")
    end
    
    it "matches whole text with spaces" do
      "{{Lorem ipsum dolor sit amet}}".split(regexp).should include("Lorem ipsum dolor sit amet")
    end
    
  end
  
  describe "process_macros method" do
    it "calls binary macro" do
      MacroProcessor.should_receive(:binary_macro)
      MacroProcessor.process_macros("Lorem ipsum {{BINARY}} dolor sit amet.", mock_context)
    end

    it "calls binary and inputs macros" do
      MacroProcessor.should_receive(:inputs_macro)
      MacroProcessor.should_receive(:binary_macro)
      MacroProcessor.process_macros("Lorem ipsum {{INPUTS}} dolor {{BINARY}} sit amet.", mock_context)
    end
    
    it "doesn't raise an error when macro doesn't exist" do
      lambda { MacroProcessor.process_macros("Lorem ipsum {{FOO}} dolor {{BAR}} sit amet.", mock_context) }.should_not raise_error
    end
    
    it "raises error when unsuitable context provided" do
      lambda { MacroProcessor.process_macros("Hello {{FOO}} World!", mock("text")) }.should raise_error
    end
    
    it "returns inputs string even if no macros provided" do
      str = "Lorem ipsum dolor sit amet."
      MacroProcessor.process_macros(str, mock_context).should eq(str)
    end
    
    describe "process macross - integration" do
      it "process {{INPUTS}} macro" do
        mock_context.stub(:inputs).and_return("inputs")
      
        out = MacroProcessor.process_macros("Lorem ipsum {{INPUTS}} dolor sit amet.", mock_context)
        out.should_not match("{{INPUTS}}")
        out.should match("inputs")
      end
    end

  end
  
  describe "binary macro" do
    it "returns algorithm binaries file name" do
      mock_context.stub(:algorithm_binary).and_return(true)
      mock_context.stub_chain(:algorithm_binary, :attachment, :data_file_name).and_return("file")

      MacroProcessor.send(:binary_macro, mock_context).should eq("file")
    end
  end

  describe "inputs macro" do
    it "returns inputs" do
      mock_context.stub(:inputs).and_return("inputs")
      MacroProcessor.send(:inputs_macro, mock_context).should eq("inputs")
    end
  end

  describe "instances count macro" do
    it "returns instances count" do
      mock_context.stub(:task_params => {:instances_count => 3})
      MacroProcessor.send(:instances_count_macro, mock_context).should eq(3)
    end
  end

  describe "instance id macro" do
    it "returns instance_id" do
      mock_context.stub(:instance_id => 1)
      MacroProcessor.send(:instance_id_macro, mock_context).should eq(1)
    end
  end

  describe "cloud user macro" do
    it "returns cloud user" do
      MacroProcessor.send(:cloud_user_macro, mock_context).should eq("euca")
    end
  end

  describe "unix uid macro" do
    it "returns context user's unix uid" do
      mock_context.stub_chain(:user, :unix_uid).and_return(1000)
      MacroProcessor.send(:unix_uid_macro, mock_context).should eq(1000)
    end
  end
end