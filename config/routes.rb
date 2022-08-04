# frozen_string_literal: true

Rails.application.routes.draw do
  root 'items#index'
  devise_for :users
  resources :items do
    resources :comments, shallow: true
  end

  resources :carts do
    member do
      post 'add_to'
      delete 'remove_from'
      put 'update_quantity'
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
