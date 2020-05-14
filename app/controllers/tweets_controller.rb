class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[show like unlike]

  def index
    @tweets = Tweet.all.order(created_at: 'DESC').includes(:user, :likes)
    @follow_users_tweets = current_user.follow_users_tweets.order(created_at: 'DESC').includes(:user, :likes)
  end

  def show; end

  def new
    @tweet = current_user.tweets.build
  end

  def create
    p tweet_params
    @tweet = current_user.tweets.build(tweet_params)

    if @tweet.save
      redirect_to root_url, notice: 'つぶやきを投稿しました。'
    else
      render :new
    end
  end

  def destroy
    tweet = current_user.tweets.find(params[:id])
    tweet.destroy
    redirect_to root_url, notice: 'つぶやきを削除しました。'
  end

  def like
    @tweet.likes.create(user_id: current_user.id)
  end

  def unlike
    @tweet.likes.find_by(user_id: current_user.id).try(:destroy)
    render :like
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:body, { images: [] })
    end
end
