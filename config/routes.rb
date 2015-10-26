Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, :controllers => {omniauth_callbacks: 'omniauth_callbacks'}

  root 'pages#index'
  get '/profile' => 'users#profile', :as => :profile


  namespace :admin do
    get '', to: 'dashboards#index', as: '/'
    get 'training', to: 'dashboards#training', as: 'training'
  end

  namespace :extension_api do
    resource :active_pages, only: [] do
      post 'tab_change'
      post 'new_page'
      post 'chrome_activated'
      post 'page_lost_focus'
    end

    resource :users do
      get :profile, on: :collection
    end

  end

  namespace :api do
    resource :dashboards, only: [] do
      get :overview, on: :collection
    end
    resource :experiments, only: [] do
      get :application_list, on: :collection
      get :application_types, on: :collection
      post :app_categorization, on: :collection
    end
  end

  get '*path' => 'pages#index'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
