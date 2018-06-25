Rails.application.routes.draw do
  get 'account_histories/index'
  get 'account_histories/destroy'
  root 'home#index'

  devise_for :users, skip: [:passwords]

  get 'accounts', to: 'accounts#index'

  resources :account_histories, only: %i[index destroy]
  resources :users, except: [:destroy] do
    resources :accounts, only: %i[index] do
      post 'transaction', to: 'accounts#transaction'
    end
  end
end
