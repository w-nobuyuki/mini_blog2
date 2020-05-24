namespace :mail do

  task likes_ranking: :environment do
    TweetMailer.ranking.deliver
  end
end
