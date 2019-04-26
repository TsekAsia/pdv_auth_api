PdvAuthApi::Engine.routes.draw do
  namespace :api do
    resources :auth, only: :create do
      post :validate, on: :collection
    end
    resources :registrations, only: :create
    resource :account, only: %i[show update] do
      patch :change_password
    end
    resources :companies, only: %i[index show]
  end
end
