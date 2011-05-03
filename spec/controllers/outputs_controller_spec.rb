require 'spec_helper'

describe OutputsController do
  fixtures :users, :tasks, :outputs

  let(:user) { users(:test_user1) }
  let(:task) { tasks(:task_1) }
  let(:base_path) { { :task_id => task.id } }
  
  before(:each) do
    sign_in user
  end

  def mock_output(stubs={})
    @mock_output ||= mock_model(Output, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all outputs as @outputs" do
      Output.stub(:all) { [mock_output] }
      get :index, base_path
      assigns(:outputs).should eq([mock_output])
    end
  end

  describe "GET show" do
    it "assigns the requested output as @output" do
      Output.stub(:find).with("37") { mock_output }
      get :show, base_path.merge(:id => "37")
      assigns(:output).should be(mock_output)
    end
  end

  # describe "GET new" do
  #   it "assigns a new output as @output" do
  #     Output.stub(:new) { mock_output }
  #     get :new, base_path
  #     assigns(:output).should be(mock_output)
  #   end
  # end

  # describe "GET edit" do
  #   it "assigns the requested output as @output" do
  #     Output.stub(:find).with("37") { mock_output }
  #     get :edit, base_path.merge(:id => "37")
  #     assigns(:output).should be(mock_output)
  #   end
  # end

  # describe "POST create" do
  #   describe "with valid params" do
  #     it "assigns a newly created output as @output" do
  #       Output.stub(:new).with({'these' => 'params'}) { mock_output(:save => true) }
  #       post :create, base_path.merge(:output => {'these' => 'params'})
  #       assigns(:output).should be(mock_output)
  #     end
  # 
  #     it "redirects to the created output" do
  #       Output.stub(:new) { mock_output(:save => true) }
  #       post :create, base_path.merge(:output => {})
  #       response.should redirect_to(output_url(mock_output))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved output as @output" do
  #       Output.stub(:new).with({'these' => 'params'}) { mock_output(:save => false) }
  #       post :create, base_path.merge(:output => {'these' => 'params'})
  #       assigns(:output).should be(mock_output)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       Output.stub(:new) { mock_output(:save => false) }
  #       post :create, base_path.merge(:output => {})
  #       response.should render_template("new")
  #     end
  #   end
  # end

  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested output" do
  #       Output.stub(:find).with("37") { mock_output }
  #       mock_output.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, base_path.merge(:id => "37", :output => {'these' => 'params'})
  #     end
  # 
  #     it "assigns the requested output as @output" do
  #       Output.stub(:find) { mock_output(:update_attributes => true) }
  #       put :update, base_path.merge(:id => "1")
  #       assigns(:output).should be(mock_output)
  #     end
  # 
  #     it "redirects to the output" do
  #       Output.stub(:find) { mock_output(:update_attributes => true) }
  #       put :update, base_path.merge(:id => "1")
  #       response.should redirect_to(output_url(mock_output))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns the output as @output" do
  #       Output.stub(:find) { mock_output(:update_attributes => false) }
  #       put :update, base_path.merge(:id => "1")
  #       assigns(:output).should be(mock_output)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       Output.stub(:find) { mock_output(:update_attributes => false) }
  #       put :update, base_path.merge(:id => "1")
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  describe "DELETE destroy" do
    it "destroys the requested output" do
      Output.stub(:find).with("37") { mock_output }
      mock_output.should_receive(:destroy)
      delete :destroy, base_path.merge(:id => "37")
    end

    it "redirects to the outputs list" do
      Output.stub(:find) { mock_output(:task => task) }
      delete :destroy, base_path.merge(:id => "1")
      response.should redirect_to(task_url(task))
    end
  end

end
