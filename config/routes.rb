Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, skip: [:passwords]

  get 'accounts', to: 'accounts#index'

  resources :users, only: [:edit] do
    resources :accounts, only: %i[index] do
      post 'transaction', to: 'accounts#transaction'
    end
  end
end
