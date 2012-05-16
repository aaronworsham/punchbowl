Punchbowl::Application.routes.draw do

  devise_for :users

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  

  match 'customers/uuid/:uuid' => 'customers#show', :as => :customer_by_uuid, :via => :get
  match 'customers/uuid/:uuid/add_network/:network' => 'customers#add_network', :as => :add_network, :via => :put
  match 'customers/uuid/:uuid/remove_network/:network' => 'customers#remove_network', :as => :remove_network, :via => :put
  match 'customers/uuid/:uuid/reauthorize/:network' => 'customers#reauthorize', :as => :reauthroize, :via => :put
  match 'customers/uuid/:uuid/posts' => 'posts#index', :as => :posts_by_customer_uuid, :via => :get


  resources :customers do
    resource :facebook do
      collection do
        get 'auth_success'
      end
    end
    resource :twitter do
      collection do
        get 'auth_success'
      end
    end
    resources :posts
  end
  resources :posts

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
  


  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
 root :to => "posts#new"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
