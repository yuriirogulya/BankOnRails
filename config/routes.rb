Rails.application.routes.draw do
  root 'home#index'
  
  devise_for :users, skip: [:passwords]

  get 'accounts', to: 'accounts#index'

  resources :users, except: [:destroy] do
    resources :accounts, except: [:show, :edit , :update] do
      post 'transaction', to: 'accounts#transaction'
    end
  end
end
