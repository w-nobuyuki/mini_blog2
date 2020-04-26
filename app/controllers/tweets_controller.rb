class TweetsController < ApplicationController
  before_action :set_tweet, only: [:destroy]

  def index
    @tweets = Tweet.all.order(created_at: 'DESC')
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = Tweet.new(tweet_params)

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
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:body)
    end
end
