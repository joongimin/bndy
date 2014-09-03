Rails.application.routes.draw do
  root 'home#index'

  resources :comments, only: [:index, :create]
  resources :photos, only: [:index]
end