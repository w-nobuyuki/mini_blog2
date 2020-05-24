namespace :mail do

  task :likes_ranking do
    TweetMailer.ranking
  end
end
