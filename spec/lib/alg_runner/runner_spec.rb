require 'spec_helper'

describe AlgRunner do
  
  describe "get user data" do
    pending
  end

  describe "init amqp" do
    pending
  end
  
  describe AlgRunner::Runner do
    let(:bunny) { mock(Bunny) }
    let(:input_queue) { mock("queue").as_null_object }
    let(:output_queue) { mock("queue", {:publish => nil}).as_null_object }
    let(:runner) { AlgRunner::Runner.new(bunny, input_queue, output_queue, Rails.logger) }
    
    describe "start! method" do
      pending
    end
  
    describe "parse_input method" do
      pending    
    end
  
    describe "send_output method" do
      it "should publish result set from algorithm to output queue" do
        bunny.should_receive(:exchange).and_return(output_queue)
        output_queue.should_receive(:publish).with(instance_of(String), instance_of(Hash))
        runner.send :send_output, "<output />"
      end
    end
  
    describe "download_binary method" do
      it "should try to download algorithm binary from given url" do
        mock_io = mock(IO)
        mock_io.should_receive(:close)
        IO.should_receive(:popen).with(/curl -o/).and_return(mock_io)
      
        runner.send :download_binary, "program.jar", "http://example.net"
      end
    end
  
    describe "launch_algorithm" do
      it "should run command without any error" do
        lambda { runner.send :launch_algorithm, "pwd" }.should_not raise_error
      end
    
      it "should caputer stdout of running cmd" do
        out = runner.send :launch_algorithm, "pwd"
        out.should_not be_empty
        out[:stdout].should_not be_empty
      end
    
      it "should capture stderr of running cmd" do
        out = runner.send :launch_algorithm, "pwd 1>&2"
        out.should_not be_empty
        out[:stderr].should_not be_empty
      end
    
      it "should run algorithm and capture it's stdout and stderr" do
        out = runner.send :launch_algorithm, "pwd ; pwd 1>&2"
        out.should_not be_empty
        out[:stdout].should_not be_empty
        out[:stderr].should_not be_empty
      end
      
      it "describes ruby command" do
        out = runner.send :launch_algorithm, "type ruby"
        out.should_not be_empty
        out[:stdout].should_not be_empty
        out[:stdout].should match(/ruby is \//)
        out[:stderr].should be_empty
      end
      
      it "should correctly unescape characters from message" do
        pending
      end
    end
  
    describe "create_output_xml method" do
      it "should create proper output xml" do
        task_output = { :stdout => "Program finished successfully.", :stderr => "File data.dat not found." }
        task_options = { :task_id => 1, :instance_id => 2 }
      
        output = runner.send :create_output_xml, task_output, task_options
        output.should_not be_empty
      
        output.should match(/<task-id>1<\/task-id>/)
        output.should match(/<params><instance-id>2<\/instance-id><\/params>/)
        output.should match(/<stdout>[^<]*<\/stdout>/)
        output.should match(/<stderr>[^<]*<\/stderr>/)
      end
    end
    
    describe "request termination" do
      pending
    end
    
  end  
end

