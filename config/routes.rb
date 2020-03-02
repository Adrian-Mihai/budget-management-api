Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'application#home'
  post :authenticate, controller: 'application'

  namespace :authenticate do
    get :decode, controller: 'authentication'
  end

  resources :users, only: :create
end
