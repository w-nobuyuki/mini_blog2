# Preview all emails at http://localhost:3000/rails/mailers/comment
class CommentPreview < ActionMailer::Preview
  def new_comment
    to_user = User.new(name: 'to', password: 'password')
    from_user = User.new(name: 'from', password: 'password')
    tweet = to_user.tweets.build(body: 'ブラックモンブラン食べたい')
    comment = tweet.comments.build(body: "こんにちは！\nブラックモンブランおいしいですよね！", user: from_user)
    CommentMailer.new_comment(comment)
  end
end
