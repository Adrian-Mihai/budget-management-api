Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  post :authenticate, controller: 'application'

  namespace :authenticated do
    get  :decode, controller: 'authentication'
  end

  resources :users, only: :create
end
