Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, skip: [:passwords]

  get 'profile', to: 'users#show'
  resources :users do
    resources :accounts
  end
end
