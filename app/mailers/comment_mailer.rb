class CommentMailer < ApplicationMailer
  def new_comment(comment)
    @comment = comment
    mail to: @comment.tweet.user.email, subject: '新しいコメントが投稿されました'
  end
end
