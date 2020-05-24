class TweetMailer < ApplicationMailer
  def ranking
    to_users = User.pluck(:email).join(',')
    @ranking = Tweet.yesterday_likes_ranking_top(10)
    mail to: to_users,
         subject: '前日の「いいね数」ランキング'
  end
end
