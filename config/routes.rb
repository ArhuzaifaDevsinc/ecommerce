# frozen_string_literal: true

Rails.application.routes.draw do
  root 'items#index'
  devise_for :users
  resources :items do
    resources :comments, shallow: true
  end
  resources :items do
    member do
      post 'add_to_cart'
      delete 'remove_from_cart'
      get 'line_item_add'
      get 'line_item_reduce'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
