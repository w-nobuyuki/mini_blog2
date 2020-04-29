Rails.application.routes.draw do
  devise_for :users
  resources :tweets, except: %i[edit show update index]
  root 'tweets#index'
end
