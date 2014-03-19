Hockey::Application.routes.draw do

  namespace :feed do
    resources :user_posts, :only => [:create]
  end

  resources :followings, :only => [:create, :destroy]

  resources :games, :only => [:show, :update]

  namespace :marker do
    resources :games, :only => :show do
      resources :goals, :only => [:index, :new, :create, :update, :destroy]
      resources :penalties, :only => [:create, :update, :destroy]
      resource :roster, :only => [:show, :new, :create, :edit, :update], :controller => "game_players"
      resources :game_goalies, :only => [:new, :create]
      resource :game_officials, :only => [:edit, :update]
      resource :game_staff_members, :only => [:new, :create, :edit, :update]
      member do
        post :activate
        post :start
        post :pause
        post :finish
        post :complete
        post :sync
        put :update_clock
        put :set_mvp
      end
    end
  end

  resources :locations, :except => [:destroy] do
    resource :scoreboard, :only => :show, :controller => "locations/scoreboards"
  end

  resources :players, :only => [:show, :edit, :update, :destroy] do
    resources :claims, :only => [:show, :new, :create], :controller => "players/claims" do
      member do
        post :approve
        post :deny
      end
    end
  end

  resources :search, :only => :index, :controller => "search_results"

  resources :teams, :only => [:index, :show, :edit, :update, :destroy], :controller => "leagues/teams" do
    resources :players, :only => [:new, :create]
    resources :staff_members
  end

  resources :leagues do
    resources :teams, :only => [:new, :create], :controller => "leagues/teams"
    resources :games, :only => [:new, :create, :edit, :update, :destroy], :controller => "leagues/games"
    resources :officials, :controller => "leagues/officials"
  end

  resources :invitations, :only => [:new, :create] do
    member do
      get :accept
      get :decline
    end
  end

  resources :system_names, :only => [:show]

  resources :team_claims, :only => [:create, :show] do
    resources :players, :only => [:edit, :update], :controller => "team_claims/players"
  end

  resources :tournaments do
    resources :games, :controller => "tournaments/games"
    resources :officials, :controller => "tournaments/officials"
    resource :teams, :only => [:edit, :update], :controller => "tournaments/teams"
  end

  devise_for :users, :controllers => {:registrations => "users/registrations" }


  resources :users, :only => [:show, :edit, :update] do
    member do
      get :impersonate
    end
    collection do
      post :system_name_available
      post :email_available
    end
  end

  resources :videos, :only => [:show, :destroy]

  match 'typeahead/get_users' => 'typeahead#get_users'

  namespace :admin do
    resource :kiosk, :except => [:edit, :update]
  end

  #
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
  # root :to => 'welcome#index'
  root :to => 'home#index'
  get 'about' => 'home#about'
  get 'terms' => 'home#terms'
  get 'privacy' => 'home#privacy'
  get 'contact' => 'home#contact'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

  match '/404', :to => 'errors#not_found'
  match '/422', :to => 'errors#server_error'
  match '/500', :to => 'errors#server_error'
end
