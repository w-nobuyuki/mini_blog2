class TweetsController < ApplicationController
  # ApplicationController で before_action して、必要に応じて skip_before_action するほうが安全
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[show like unlike]

  def index
    # created_at に index つけたほうがよさそう
    # pagination をつけたほうがよさそう
    # includes つけてるの good
    # .all 不要
    @tweets = Tweet.all.order(created_at: 'DESC').includes(:user, :likes)
    # ページとして分けたほうがシステムには優しそう
    @follow_users_tweets = current_user.follow_users_tweets.order(created_at: 'DESC').includes(:user, :likes)
  end

  def show; end

  # scaffold みたいで読みやすい
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
    # リソースの引き方の違いをアクションで吸収することはあまりしない。routing 分けるのがよさそう
    tweet = current_user.tweets.find(params[:id])
    tweet.destroy
    redirect_to root_url, notice: 'つぶやきを削除しました。'
  end

  def like
    # find_or_create_by 使わないと多重に作ろうとしてエラーになりそう
    # @tweet.likes.find_or_create_by(user: current_user)
    @tweet.likes.create(user_id: current_user.id)
  end

  def unlike
    # destroy! を使ってエラーを無視しないようにする
    # @tweet.likes.find_by(user_id: current_user.id)&.destroy!
    @tweet.likes.find_by(user_id: current_user.id).try(:destroy)
    render :like
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:body, :image)
    end
end
