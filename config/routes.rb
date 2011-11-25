CloudGunther::Application.routes.draw do
  root :to => "dashboard#index"
  match "/", :to => "dashboard#index", :as => :dashboard
  
  resource :dashboard, :controller => "dashboard", :only => [:index] do
    get :queues
  end

  devise_for :users,
             :controllers => { :sessions => "sessions", :registrations => "registrations" },
             :path => "account"
  match "/account" => redirect("/account/sign_in")

  resources :tasks do
    member do
      post :run
      post :terminate_instance
      post :terminate_all_instances
    end
    resources :outputs, :only => [:index, :show, :destroy]
  end
  
  resources :attachments, :only => [:show, :destroy]
  
  resources :algorithms do
    resources :binaries, :as => :algorithm_binaries, :controller => :algorithm_binaries
  end
  
  scope "/admin" do
    resources :delayed_jobs, :only => [:index, :show, :destroy]
    
    resources :users do
      collection do
        get :tokeninput
        get :registrations
      end
      member do
        get :change_password
        post :approve
        post :reject
      end
    end
  
    resources :user_groups do
      collection do
        get :tokeninput
      end
    end
    
    resources :cloud_engines do
      member do
        post :test_connection
        get :availability_zones
        get :availability_zones_info
      end

      resources :images do
        member do
          post :verify_availability
        end
      end
    end
    
    mount Resque::Server, :at => "/resque"  
  end
  
  
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
