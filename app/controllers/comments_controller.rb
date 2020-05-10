class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet
  before_action :set_comments, only: %i[index create]

  def index
    @comment = @tweet.comments.build
  end

  def create
    @comment = @tweet.comments.build(comment_params)
    if @comment.save
      CommentMailer.new_comment(@comment).deliver
      redirect_to root_url, notice: 'コメントを送りました。'
    else
      render :index
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
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
      params.require(:comment).permit(:body).merge(user: current_user)
    end
end
