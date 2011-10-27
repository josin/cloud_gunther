require 'spec_helper'

describe DelayedJobsController do
  fixtures :users, :user_groups, :delayed_jobs
  
  let(:user) { users(:test_user1) }
  
  before(:each) do
    sign_in user
  end

  # This should return the minimal set of attributes required to create a valid
  # DelayedJob. As you add validations to DelayedJob, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe "GET index" do
    it "assigns all delayed_jobs as @delayed_jobs" do
      delayed_job = DelayedJob.create! valid_attributes
      get :index
      assigns(:delayed_jobs).should eq([delayed_job])
    end
  end

  describe "GET show" do
    it "assigns the requested delayed_job as @delayed_job" do
      delayed_job = DelayedJob.create! valid_attributes
      get :show, :id => delayed_job.id.to_s
      assigns(:delayed_job).should eq(delayed_job)
    end
  end

  # describe "GET new" do
  #   it "assigns a new delayed_job as @delayed_job" do
  #     get :new
  #     assigns(:delayed_job).should be_a_new(DelayedJob)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested delayed_job as @delayed_job" do
  #     delayed_job = DelayedJob.create! valid_attributes
  #     get :edit, :id => delayed_job.id.to_s
  #     assigns(:delayed_job).should eq(delayed_job)
  #   end
  # end
  # 
  # describe "POST create" do
  #   describe "with valid params" do
  #     it "creates a new DelayedJob" do
  #       expect {
  #         post :create, :delayed_job => valid_attributes
  #       }.to change(DelayedJob, :count).by(1)
  #     end
  # 
  #     it "assigns a newly created delayed_job as @delayed_job" do
  #       post :create, :delayed_job => valid_attributes
  #       assigns(:delayed_job).should be_a(DelayedJob)
  #       assigns(:delayed_job).should be_persisted
  #     end
  # 
  #     it "redirects to the created delayed_job" do
  #       post :create, :delayed_job => valid_attributes
  #       response.should redirect_to(DelayedJob.last)
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved delayed_job as @delayed_job" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       DelayedJob.any_instance.stub(:save).and_return(false)
  #       post :create, :delayed_job => {}
  #       assigns(:delayed_job).should be_a_new(DelayedJob)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       DelayedJob.any_instance.stub(:save).and_return(false)
  #       post :create, :delayed_job => {}
  #       response.should render_template("new")
  #     end
  #   end
  # end
  # 
  # describe "PUT update" do
  #   describe "with valid params" do
  #     it "updates the requested delayed_job" do
  #       delayed_job = DelayedJob.create! valid_attributes
  #       # Assuming there are no other delayed_jobs in the database, this
  #       # specifies that the DelayedJob created on the previous line
  #       # receives the :update_attributes message with whatever params are
  #       # submitted in the request.
  #       DelayedJob.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => delayed_job.id, :delayed_job => {'these' => 'params'}
  #     end
  # 
  #     it "assigns the requested delayed_job as @delayed_job" do
  #       delayed_job = DelayedJob.create! valid_attributes
  #       put :update, :id => delayed_job.id, :delayed_job => valid_attributes
  #       assigns(:delayed_job).should eq(delayed_job)
  #     end
  # 
  #     it "redirects to the delayed_job" do
  #       delayed_job = DelayedJob.create! valid_attributes
  #       put :update, :id => delayed_job.id, :delayed_job => valid_attributes
  #       response.should redirect_to(delayed_job)
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns the delayed_job as @delayed_job" do
  #       delayed_job = DelayedJob.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       DelayedJob.any_instance.stub(:save).and_return(false)
  #       put :update, :id => delayed_job.id.to_s, :delayed_job => {}
  #       assigns(:delayed_job).should eq(delayed_job)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       delayed_job = DelayedJob.create! valid_attributes
  #       # Trigger the behavior that occurs when invalid params are submitted
  #       DelayedJob.any_instance.stub(:save).and_return(false)
  #       put :update, :id => delayed_job.id.to_s, :delayed_job => {}
  #       response.should render_template("edit")
  #     end
  #   end
  # end

  describe "DELETE destroy" do
    it "destroys the requested delayed_job" do
      delayed_job = DelayedJob.create! valid_attributes
      expect {
        delete :destroy, :id => delayed_job.id.to_s
      }.to change(DelayedJob, :count).by(-1)
    end

    it "redirects to the delayed_jobs list" do
      delayed_job = DelayedJob.create! valid_attributes
      delete :destroy, :id => delayed_job.id.to_s
      response.should redirect_to(delayed_jobs_url)
    end
  end

end
