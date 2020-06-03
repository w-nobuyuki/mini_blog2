class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet
  before_action :set_comments, only: %i[index create]

  def index
    @comments = @tweet.comments.includes(:user)
  end

  def create
    @comment = @tweet.comments.build(comment_params)
    # 具体的なデータの設定はこちらで
    # @comment.user = current_user
    if @comment.save
      # deliver => deliver_now, deliver_later
      CommentMailer.new_comment(@comment).deliver
      # この redirect は turbolinks が拾ってくれている
      # html 以外のときは respond_to { |format| ... } を使うと特殊感が伝わる
      redirect_to root_url, notice: 'コメントを送りました。'
    else
      # index と create の view を分けると @comments のロードが不要になる
      # create では form 部分だけを置き換える
      render :index
    end
  end

  def destroy
    # アクション分けたほうがよさそう
    comment = current_user.comments.find(params[:id])
    # destroy!
    comment.destroy
    redirect_to root_url, notice: 'コメントを削除しました。'
  end

  private

    def set_tweet
      @tweet = Tweet.find(params[:tweet_id])
    end

    def set_comments
      @comments = @tweet.comments.includes(:user)
    end

    def comment_params
      # ここは strong parameter で項目を絞るのが目的の場所なので具体的なデータは含めない
      params.require(:comment).permit(:body).merge(user: current_user)
    end
end
