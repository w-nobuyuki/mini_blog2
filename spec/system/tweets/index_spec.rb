require 'rails_helper'

RSpec.describe 'Tweets#index', type: :system do
  before do
    first_user = User.create(name: 'first', password: 'password')
    second_user = User.create(name: 'second', password: 'password')
    first_user.tweets.create(body: 'tweet1', created_at: '2020/04/26 20:39')
    first_user.tweets.create(body: 'tweet2', created_at: '2020/09/26 1:39')
    second_user.tweets.create(body: 'tweet3', created_at: '2020/11/26 12:39')
    visit new_user_session_path
    fill_in 'user[name]',	with: 'first'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
    visit root_path
  end

  it 'は新規投稿画面へ遷移するボタンが存在すること' do
    expect(page).to have_link '新規投稿画面', href: new_tweet_path
  end

  it 'は各投稿にユーザ名が含まれること' do
    tweets = all('.card-title').map(&:text)
    expect(tweets).to eq %w[second first first]
  end

  it 'は各投稿に本文が含まれること' do
    tweets = all('.card-text').map(&:text)
    expect(tweets).to eq %w[tweet3 tweet2 tweet1]
  end

  it 'は各投稿に投稿日時（YYYY/MM/DD hh:mm）が含まれること' do
    tweets = all('.card-footer').map { |tweet| tweet.first('.col').text }
    expect(tweets).to eq ['2020/11/26 12:39', '2020/09/26 01:39', '2020/04/26 20:39']
  end

  it 'は自身の投稿に削除リンクが含まれること' do
    tweets = all('.card-footer').map { |tweet| tweet.all('.col').last.text }
    expect(tweets).to eq ['', '削除', '削除']
  end

  it 'は自身の投稿を削除できること' do
    within all('.card').last do
      accept_confirm do
        click_link '削除'
      end
    end
    expect(page).to have_content 'つぶやきを削除しました。'
  end
end