Rails.application.routes.draw do
  # HACK: registrationsコントローラのcancelとdestroyは利用していない
  devise_for :user, only: %i[sessions registrations]

  # except より only 使ったほうが安全
  # resources :tweets, except: %i[edit update index] do
  resources :tweets, only: %i[show new create destroy] do
    # show => like 一覧ページ
    member do
      post :like
      delete :unlike
    end

    # index => いいねした人リスト
    # create => いいね
    # destroy => いいね取り下げ
    resources :likes, only: %i[index create destroy]

    resources :comments, only: %i[index create destroy]
  end

  resources :users, only: :show do
    member do
      post :follow
      delete :unfollow
    end
  end

  namespace :users do
    resources :tweets, only: %i[destroy]
    # def set_tweet
    #   @tweet = current_user.tweets.find(params[:id])
    # end
  end

  namespace :admins do
    resources :tweets
  end

  root 'tweets#index'
end
