require 'spec_helper'

describe AlgorithmBinariesController do
  fixtures :users, :algorithms, :algorithm_binaries
  
  let(:user) { users(:test_user1) }
  let(:algorithm) { algorithms(:algorithm_1) }
  let(:base_path) { { :algorithm_id => algorithm.id } }
  
  before(:each) do
    sign_in user
  end
  
  def mock_algorithm_binary(stubs={})
    @mock_algorithm_binary ||= mock_model(AlgorithmBinary, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all algorithm_binaries as @algorithm_binaries" do
      # AlgorithmBinary.stub(:all) { [mock_algorithm_binary] }
      get :index, base_path
      assigns(:algorithm_binaries).should eq(algorithm.algorithm_binaries)
    end
  end

  describe "GET show" do
    it "assigns the requested algorithm_binary as @algorithm_binary" do
      AlgorithmBinary.stub(:find).with("37") { mock_algorithm_binary }
      get :show, base_path.merge(:id => "37")
      assigns(:algorithm_binary).should be(mock_algorithm_binary)
    end
  end

  describe "GET new" do
    it "assigns a new algorithm_binary as @algorithm_binary" do
      AlgorithmBinary.stub(:new) { mock_algorithm_binary }
      get :new, base_path
      assigns(:algorithm_binary).should be(mock_algorithm_binary)
    end
  end

  describe "GET edit" do
    it "assigns the requested algorithm_binary as @algorithm_binary" do
      AlgorithmBinary.stub(:find).with("37") { mock_algorithm_binary }
      get :edit, base_path.merge(:id => "37")
      assigns(:algorithm_binary).should be(mock_algorithm_binary)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created algorithm_binary as @algorithm_binary" do
        AlgorithmBinary.should_receive(:new).and_return(mock_algorithm_binary)
        mock_algorithm_binary.should_receive(:algorithm=)
        mock_algorithm_binary.should_receive(:user=)
        mock_algorithm_binary.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)

        post :create, base_path.merge(:algorithm_binary => {'these' => 'params'})
        assigns(:algorithm_binary).should be(mock_algorithm_binary)
      end
    
      it "redirects to the created algorithm_binary" do
        AlgorithmBinary.should_receive(:new).and_return(mock_algorithm_binary)
        mock_algorithm_binary.should_receive(:update_attributes).and_return(true)
        
        post :create, base_path.merge(:algorithm_binary => {})
        response.should redirect_to(algorithm_url(algorithm))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved algorithm_binary as @algorithm_binary" do
        AlgorithmBinary.should_receive(:new).and_return(mock_algorithm_binary)
        mock_algorithm_binary.should_receive(:algorithm=)
        mock_algorithm_binary.should_receive(:user=)
        mock_algorithm_binary.should_receive(:update_attributes).with({'these' => 'params'}).and_return(false)

        post :create, base_path.merge(:algorithm_binary => {'these' => 'params'})
        assigns(:algorithm_binary).should be(mock_algorithm_binary)
      end
    
      it "re-renders the 'new' template" do
        AlgorithmBinary.should_receive(:new).and_return(mock_algorithm_binary)
        mock_algorithm_binary.should_receive(:update_attributes).and_return(false)
        
        post :create, base_path.merge(:algorithm_binary => {})
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested algorithm_binary" do
        AlgorithmBinary.stub(:find).with("37") { mock_algorithm_binary }
        mock_algorithm_binary.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, base_path.merge(:id => "37", :algorithm_binary => {'these' => 'params'})
      end

      it "assigns the requested algorithm_binary as @algorithm_binary" do
        AlgorithmBinary.stub(:find) { mock_algorithm_binary(:update_attributes => true) }
        put :update, base_path.merge(:id => "1")
        assigns(:algorithm_binary).should be(mock_algorithm_binary)
      end

      it "redirects to the algorithm" do
        AlgorithmBinary.stub(:find) { mock_algorithm_binary(:update_attributes => true) }
        put :update, base_path.merge(:id => "1")
        response.should redirect_to(algorithm_url(algorithm))
      end
    end

    describe "with invalid params" do
      it "assigns the algorithm_binary as @algorithm_binary" do
        AlgorithmBinary.stub(:find) { mock_algorithm_binary(:update_attributes => false) }
        put :update, base_path.merge(:id => "1")
        assigns(:algorithm_binary).should be(mock_algorithm_binary)
      end

      it "re-renders the 'edit' template" do
        AlgorithmBinary.stub(:find) { mock_algorithm_binary(:update_attributes => false) }
        put :update, base_path.merge(:id => "1")
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested algorithm_binary" do
      AlgorithmBinary.stub(:find).with("37") { mock_algorithm_binary }
      mock_algorithm_binary.should_receive(:destroy)
      delete :destroy, base_path.merge(:id => "37")
    end

    it "redirects to the algorithm_binaries list" do
      AlgorithmBinary.stub(:find) { mock_algorithm_binary }
      delete :destroy, base_path.merge(:id => "1")
      response.should redirect_to(algorithm_url(algorithm))
    end
  end

end
