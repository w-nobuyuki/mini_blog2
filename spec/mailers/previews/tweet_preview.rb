# Preview all emails at http://localhost:3000/rails/mailers/tweet
class TweetPreview < ActionMailer::Preview
  def ranking
    TweetMailer.ranking
  end
end
