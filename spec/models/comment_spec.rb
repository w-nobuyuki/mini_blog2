require 'rails_helper'

RSpec.describe Comment, type: :model do
  before do
    @user = User.create(name: 'testuser', password: 'password')
    @tweet = @user.tweets.build(body: 'tweet')
  end

  it 'はツイートID, ユーザーID, 本文が存在すれば有効であること' do
    comment = @tweet.comments.build(user_id: @user.id, body: 'コメント')
    expect(comment).to be_valid
  end

  it 'は本文がなければ無効であること' do
    comment = Comment.new(body: nil)
    comment.valid?
    expect(comment.errors[:body]).to include('を入力してください')
  end

  it 'は本文の文字数が141字以上の場合無効であること' do
    comment = Comment.new(body: Faker::Lorem.characters(number: 141))
    comment.valid?
    expect(comment.errors[:body]).to include('は140文字以内で入力してください')
  end

  it 'は本文の文字数が140字であれば有効であること' do
    comment = @tweet.comments.build(user_id: @user.id, body: Faker::Lorem.characters(number: 140))
    expect(comment).to be_valid
  end

  it 'はユーザーIDが空なら無効であること' do
    comment = Comment.new
    comment.valid?
    expect(comment.errors[:user]).to include('を入力してください')
  end

  it 'はツイートIDが空なら無効であること' do
    comment = Comment.new
    comment.valid?
    expect(comment.errors[:tweet]).to include('を入力してください')
  end
end
