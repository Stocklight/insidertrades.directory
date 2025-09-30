require "blazer"

Rails.application.routes.draw do
  resource :session do
    member do
      get :verify
      post :verify_code
    end
  end

  get "signin", to: "sessions#new"
  post "signin", to: "sessions#create"
  get "verify", to: "sessions#verify"
  post "verify", to: "sessions#verify_code"
  post "google-signin", to: "sessions#create_for_google", as: :google_signin
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Analytics dashboard - protected route
  mount Blazer::Engine, at: "blazer"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # SEO-friendly blog routes for technical construction posts
  get "built-with-rails", to: "blog#index", as: :built_with_rails
  get "built-with-rails/:slug", to: "blog#show", as: :built_with_rails_post

  # Defines the root path route ("/")
  root "blog#index"
end
