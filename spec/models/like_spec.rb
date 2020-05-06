require 'rails_helper'

RSpec.describe Like, type: :model do
  before do
    @user1 = User.create(name: 'FirstUser', password: 'password')
    user2 = User.create(name: 'SecondUser', password: 'password')
    @tweet = user2.tweets.create(body: '本文')
  end

  it 'は1つのツイートに対して同じ人が何度もいいねできないこと' do
    @tweet.likes.create(user_id: @user1.id)
    duplicate_like = @tweet.likes.build(user_id: @user1.id)
    duplicate_like.valid?
    expect(duplicate_like.errors[:tweet_id]).to include 'はすでに存在します'
  end
end
