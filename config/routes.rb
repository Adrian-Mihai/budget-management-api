Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'home#index'

  namespace :authenticate do
    namespace :users do
      resources :transactions, only: %i[index create destroy]
    end

    resources :users, only: %i[] do
      get :decode, on: :collection
    end
  end

  resources :users, only: :create do
    post :authenticate, on: :collection
  end
end
