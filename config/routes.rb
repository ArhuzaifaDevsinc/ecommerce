# frozen_string_literal: true

Rails.application.routes.draw do
  root 'items#index'
  devise_for :users
  resources :items do
    resources :comments, shallow: true
    collection do
      get :search
    end
  end

  resources :carts do
    member do
      post 'add_to'
      delete 'remove_from'
      put 'update_quantity'
    end
    collection do
      get 'show'
    end
  end

  namespace :paypal do
    resources :checkouts, only: [:create] do
      collection do
        get :complete
      end
    end
  end
end
