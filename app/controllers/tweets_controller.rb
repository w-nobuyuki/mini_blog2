class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: [:destroy]

  def index
    @tweets = Tweet.all.order(created_at: 'DESC').includes(:user)
    @follow_users_tweets = current_user.follow_users_tweets.order(created_at: 'DESC').includes(:user)
  end

  def new
    @tweet = current_user.tweets.build
  end

  def create
    @tweet = current_user.tweets.build(tweet_params)

    if @tweet.save
      redirect_to root_url, notice: 'つぶやきを投稿しました。'
    else
      render :new
    end
  end

  def destroy
    @tweet.destroy
    redirect_to root_url, notice: 'つぶやきを削除しました。'
  end

  private
    def set_tweet
      @tweet = current_user.tweets.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:body)
    end
end
