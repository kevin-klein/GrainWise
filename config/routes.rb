Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  resources :users
  resources :strains
  resources :tags
  resources :sites
  resources :maps
  resources :grains do
    resources :update_grave
    collection do
      get :stats
      get :export
      get :export_outlines
      get :orientations
    end
  end
  resources :figures do
    member do
      get :preview
    end
  end
  resources :page_images
  resources :uploads do
    resources :upload_items
    member do
      post :update_site
      get :assign_site
      get :assign_tags
      post :update_tags
      get :progress
      get :stats
      get :radar
      get :analyze
      get :summary
    end
    # get :delete, on: :member
  end

  get "/login", to: "user_sessions#login"
  get "/logout", to: "user_sessions#logout"
  post "/login", to: "user_sessions#code"
  post "/login_code", to: "user_sessions#login_code"

  root "grains#index"
end
