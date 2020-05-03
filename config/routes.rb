Rails.application.routes.draw do
  # HACK: registrationsコントローラのcancelとdestroyは利用していない
  devise_for :user, only: %i[sessions registrations]
  resources :tweets, except: %i[edit show update index]
  resources :users, only: :show do
    member do
      post :follow
      delete :unfollow
    end
  end
  root 'tweets#index'
end
