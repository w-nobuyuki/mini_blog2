Rails.application.routes.draw do
  devise_for :users
  resources :tweets, except: %i[edit show update index]
  resources :users, only: :show
  root 'tweets#index'
end
