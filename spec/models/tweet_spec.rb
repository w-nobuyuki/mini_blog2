require 'rails_helper'

RSpec.describe Tweet, type: :model do
  it 'は本文がなければ無効であること' do
    tweet = Tweet.new(body: nil)
    tweet.valid?
    expect(tweet.errors[:body]).to include("can't be blank")
  end

  it 'は本文の文字数が140字であれば有効であること' do
    tweet = Tweet.new(body: Faker::Lorem.characters(number: 140))
    expect(tweet).to be_valid
  end

  it 'は本文の文字数が141字であれば無効であること' do
    tweet = Tweet.new(body: Faker::Lorem.characters(number: 141))
    tweet.valid?
    expect(tweet.errors[:body]).to include('is too long (maximum is 140 characters)')
  end
end
