require 'rails_helper'

RSpec.describe Tweet, type: :model do
  it 'は本文がなければ無効であること' do
    tweet = Tweet.new(body: nil)
    tweet.valid?
    expect(tweet.errors[:body]).to include('を入力してください')
  end

  it 'は本文の文字数が140字であれば有効であること' do
    user = User.create(name: 'testuser', password: 'password')
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
end
