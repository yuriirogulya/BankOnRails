Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, skip: [:passwords]

  get 'transactions/index'
  get 'transactions/destroy'

  get 'accounts', to: 'accounts#index'

  resources :transactions, only: %i[index destroy]
  resources :users, except: [:destroy] do
    resources :accounts, only: %i[index] do
      post 'transaction', to: 'accounts#transaction'
    end
  end
end
