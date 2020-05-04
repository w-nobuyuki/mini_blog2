require 'rails_helper'

RSpec.describe User, type: :model do
  it 'はユーザー名、パスワードがあれば有効であること' do
    user = User.new(name: 'testuser', password: 'password')
    expect(user).to be_valid
  end

  it 'はユーザ名がなければ無効であること' do
    user = User.new(password: 'password')
    user.valid?
    expect(user.errors[:name]).to include('を入力してください')
  end

  it 'はユーザー名の文字数が21字以上の場合無効であること' do
    user = User.new(
      name: Faker::Lorem.characters(number: 21, min_alpha: 21),
      password: 'password'
    )
    user.valid?
    expect(user.errors[:name]).to include('は20文字以内で入力してください')
  end

  it 'はユーザー名に半角アルファベット以外の文字を含む場合無効であること' do
    ['あ', '1', '@', 'a a'].each do |value|
      user = User.new(name: value)
      user.valid?
      expect(user.errors[:name]).to include('は不正な値です')
    end
  end

  it 'は重複したユーザー名なら無効であること' do
    User.create(name: 'testuser', password: 'password')
    user = User.new(name: 'testuser')
    user.valid?
    expect(user.errors[:name]).to include('はすでに存在します')
  end

  it 'はプロフィールの文字数が201字以上の場合無効であること' do
    user = User.new(profile: Faker::Lorem.characters(number: 201))
    user.valid?
    expect(user.errors[:profile]).to include('は200文字以内で入力してください')
  end

  it 'はパスワードがなければ無効であること' do
    user = User.new
    user.valid?
    expect(user.errors[:password]).to include('を入力してください')
  end

  it 'はパスワードの文字数が6文字未満の場合無効であること' do
    user = User.new(password: 'passw')
    user.valid?
    expect(user.errors[:password]).to include('は6文字以上で入力してください')
  end

  it 'は対象のユーザーをフォローしているかどうかの真偽値を返すこと' do
    user1 = User.create(name: 'one', password: 'password')
    user2 = User.create(name: 'two', password: 'password')
    user3 = User.create(name: 'three', password: 'password')
    user1.follows.create(follow_user_id: user2.id)
    expect(user1.following?(user2)).to eq true
    expect(user1.following?(user3)).to eq false
  end
end
