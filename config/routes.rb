PdvAuthApi::Engine.routes.draw do
  namespace :api do
    resources :auth, only: :create do
      post :validate, on: :collection
    end
    resources :registrations, only: :create
  end
end
