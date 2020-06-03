class TweetMailer < ApplicationMailer
  def ranking
    to_users = User.pluck(:email).join(',')
    # メールに含めるデータの集計は外で実行して、パラメータとして受け取る
    @ranking = Tweet.yesterday_likes_ranking_top(10)
    # to: に全ユーザーのメールアドレスが書いてある！
    mail to: to_users,
         subject: '前日の「いいね数」ランキング'
  end
end
