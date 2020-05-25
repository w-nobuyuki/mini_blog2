require 'rails_helper'

RSpec.describe Tweet, type: :model do
  before do
    @first = User.create(name: 'first', email: 'first@test.co.jp', password: 'password')
    @second = User.create(name: 'second', email: 'second@test.co.jp', password: 'password')
    @third = User.create(name: 'third', email: 'third@test.co.jp', password: 'password')
    @first_tweet = Tweet.create(user: @first, body: 'first body')
    @second_tweet = Tweet.create(user: @second, body: 'second body')
    @third_tweet = Tweet.create(user: @third, body: 'third body')
  end

  it 'は本文がなければ無効であること' do
    tweet = Tweet.new(body: nil)
    tweet.valid?
    expect(tweet.errors[:body]).to include('を入力してください')
  end

  it 'は本文の文字数が140字であれば有効であること' do
    user = User.create(name: 'testuser', email: 'testuser@test.co.jp', password: 'password')
    tweet = user.tweets.build(body: Faker::Lorem.characters(number: 140))
    expect(tweet).to be_valid
  end

  it 'は本文の文字数が141字以上の場合無効であること' do
    tweet = Tweet.new(body: Faker::Lorem.characters(number: 141))
    tweet.valid?
    expect(tweet.errors[:body]).to include('は140文字以内で入力してください')
  end

  it 'はユーザーが空なら無効であること' do
    tweet = Tweet.new(body: Faker::Lorem.characters(number: 140))
    tweet.valid?
    expect(tweet.errors[:user]).to include('を入力してください')
  end

  it 'は前日のいいね数のランキングを出せること' do
    @first_tweet.likes.create(user: @first, created_at: 1.days.ago)
    @first_tweet.likes.create(user: @second, created_at: 1.days.ago)
    @first_tweet.likes.create(user: @third, created_at: 1.days.ago)
    @second_tweet.likes.create(user: @first, created_at: 1.days.ago)
    @second_tweet.likes.create(user: @third, created_at: 1.days.ago)
    @third_tweet.likes.create(user: @first, created_at: 1.days.ago)
    expect(Tweet.yesterday_likes_ranking_top(3))
      .to eq [
        { rank: 1, count: 3, tweet: @first_tweet },
        { rank: 2, count: 2, tweet: @second_tweet },
        { rank: 3, count: 1, tweet: @third_tweet }
      ]
  end

  it 'のいいねランキングはいいね数が同数の場合は同順位になること' do
    @first_tweet.likes.create(user: @second, created_at: 1.days.ago)
    @first_tweet.likes.create(user: @third, created_at: 1.days.ago)
    @second_tweet.likes.create(user: @first, created_at: 1.days.ago)
    @second_tweet.likes.create(user: @third, created_at: 1.days.ago)
    @third_tweet.likes.create(user: @first, created_at: 1.days.ago)
    expect(Tweet.yesterday_likes_ranking_top(2))
      .to eq [
        { rank: 1, count: 2, tweet: @first_tweet },
        { rank: 1, count: 2, tweet: @second_tweet }
      ]
  end

  it 'のいいねランキングはいいね数が同数の順位の次の順位は人数に合わせた順位になること' do
    @first_tweet.likes.create(user: @second, created_at: 1.days.ago)
    @first_tweet.likes.create(user: @third, created_at: 1.days.ago)
    @second_tweet.likes.create(user: @first, created_at: 1.days.ago)
    @second_tweet.likes.create(user: @third, created_at: 1.days.ago)
    @third_tweet.likes.create(user: @first, created_at: 1.days.ago)
    expect(Tweet.yesterday_likes_ranking_top(3))
      .to eq [
        { rank: 1, count: 2, tweet: @first_tweet },
        { rank: 1, count: 2, tweet: @second_tweet },
        { rank: 3, count: 1, tweet: @third_tweet }
      ]
  end
end
