Rails.application.routes.draw do
  resources :tweets, except: %i[edit show update index]
  root 'tweets#index'
end
