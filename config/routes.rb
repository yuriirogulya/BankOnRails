Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, skip: [:passwords]

  get 'profile', to: 'accounts#index'
  resources :users do
    resources :accounts
  end
end
