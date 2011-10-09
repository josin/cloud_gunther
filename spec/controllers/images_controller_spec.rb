require 'spec_helper'

describe ImagesController do
  fixtures :users, :cloud_engines#, :images
  
  let(:user) { users(:test_user1) }
  let(:cloud_engine) { cloud_engines(:cloud_engine_1) }
  let(:base_path) { { :cloud_engine_id => cloud_engine.id } }
  
  before(:each) do
    sign_in user
  end

  def mock_image(stubs={})
    @mock_image ||= mock_model(Image, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all images as @images" do
      Image.stub_chain(:metasearch, :paginate).and_return([mock_image])
      get :index, base_path
      assigns(:images).should eq([mock_image])
    end
  end

  describe "GET show" do
    it "assigns the requested image as @image" do
      Image.stub(:find).with("37") { mock_image }
      get :show, base_path.merge(:id => "37")
      assigns(:image).should be(mock_image)
    end
  end

  describe "GET new" do
    it "assigns a new image as @image" do
      Image.stub(:new) { mock_image }
      get :new, base_path
      assigns(:image).should be(mock_image)
    end
  end

  describe "GET edit" do
    it "assigns the requested image as @image" do
      Image.stub(:find).with("37") { mock_image }
      get :edit, base_path.merge(:id => "37")
      assigns(:image).should be(mock_image)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created image as @image" do
        Image.stub(:new).with({'these' => 'params'}) { mock_image(:save => true) }
        post :create, base_path.merge(:image => {'these' => 'params'})
        assigns(:image).should be(mock_image)
      end

      it "redirects to the created image" do
        Image.stub(:new) { mock_image(:save => true) }
        post :create, base_path.merge(:image => {})
        response.should redirect_to(cloud_engine_image_url(cloud_engine, mock_image))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved image as @image" do
        Image.stub(:new).with({'these' => 'params'}) { mock_image(:save => false) }
        post :create, base_path.merge(:image => {'these' => 'params'})
        assigns(:image).should be(mock_image)
      end

      it "re-renders the 'new' template" do
        Image.stub(:new) { mock_image(:save => false) }
        post :create, base_path.merge(:image => {})
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested image" do
        Image.stub(:find).with("37") { mock_image }
        mock_image.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, base_path.merge(:id => "37", :image => {'these' => 'params'})
      end

      it "assigns the requested image as @image" do
        Image.stub(:find) { mock_image(:update_attributes => true) }
        put :update, base_path.merge(:id => "1")
        assigns(:image).should be(mock_image)
      end

      it "redirects to the image" do
        Image.stub(:find) { mock_image(:update_attributes => true) }
        put :update, base_path.merge(:id => "1")
        response.should redirect_to(cloud_engine_image_url(cloud_engine, mock_image))
      end
    end

    describe "with invalid params" do
      it "assigns the image as @image" do
        Image.stub(:find) { mock_image(:update_attributes => false) }
        put :update, base_path.merge(:id => "1")
        assigns(:image).should be(mock_image)
      end

      it "re-renders the 'edit' template" do
        Image.stub(:find) { mock_image(:update_attributes => false) }
        put :update, base_path.merge(:id => "1")
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested image" do
      Image.stub(:find).with("37") { mock_image }
      mock_image.should_receive(:destroy)
      delete :destroy, base_path.merge(:id => "37")
    end

    it "redirects to the images list" do
      Image.stub(:find) { mock_image }
      delete :destroy, base_path.merge(:id => "1")
      response.should redirect_to(cloud_engine_images_url(cloud_engine.id))
    end
  end

end
