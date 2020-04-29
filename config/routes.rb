Rails.application.routes.draw do
  # HACK: registrationsコントローラのcancelとdestroyは利用していない
  devise_for :user, only: [:sessions, :registrations]
  resources :tweets, except: %i[edit show update index]
  resources :users, only: :show
  root 'tweets#index'
end
