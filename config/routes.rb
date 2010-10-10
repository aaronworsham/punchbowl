Punchbowl::Application.routes.draw do
  get "accomplishments/new"

  get "accomplishments/create"

  get "badges/show"

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
  
  match 'posts/success' => 'posts#success'
  match 'rewards/token/:token' => 'rewards#edit', :as => :rewards_token
  match 'customers/uuid/:uuid' => 'customers#show', :as => :customer_by_uuid, :via => :get
  match 'customers/uuid/:uuid' => 'customers#update', :as => :customer_by_uuid, :via => :put
  match 'customers/test/uuid/:uuid' => 'customers#test', :as => :test_customer_by_uuid
  match 'customers/email/:email' => 'customers#show', :as => :customer_by_email
  match 'badges/name/:badge_name' => 'badges#show', :as => :badge_by_name

  resource :gift_of_mango
  resource :mango_tango
  resources :mango_badges
  resource :facebook 
  resource :twitter 
  resources :accomplishments
  resources :rewards
  resources :customers 
  resources :posts do
    resource :facebook do
      member do
        get  'post_message'
        get 'auth'
      end
    end
    resource :twitter do
      member do
        get  'post_message'
        get 'auth'
      end
    end
  end

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
  
  resources :badges
    namespace :admin do
      resources :badges
      resources :languages
    end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
 root :to => "punchbowl#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
