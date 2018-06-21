Rails.application.routes.draw do
  root 'home#index'
  devise_for :users, skip: [:passwords]

  get 'profile', to: 'accounts#index'
  resources :users, except: [:destroy] do
    resources :accounts do
      post 'transaction', to: 'accounts#transaction'
    end
  end
end
