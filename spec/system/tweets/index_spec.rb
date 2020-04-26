require 'rails_helper'

RSpec.describe 'Tweets#index', type: :system do
  before do
    Tweet.create(body: 'tweet1', created_at: '2020/04/26 20:39')
    Tweet.create(body: 'tweet2', created_at: '2020/09/26 1:39')
    Tweet.create(body: 'tweet3', created_at: '2020/11/26 12:39')
    visit root_path
  end
  it 'は新規投稿画面へ遷移するボタンが存在すること' do
    has_link?(new_tweet_path)
  end
  it 'は各投稿に本文が含まれること' do
    tweets = all('.card-body').map(&:text)
    expect(tweets).to eq %w[tweet3 tweet2 tweet1]
  end
  it 'は各投稿に投稿日時（YYYY/MM/DD hh:mm）が含まれること' do
    tweets = all('.card-footer').map { |tweet| tweet.first('.col').text }
    expect(tweets).to eq ['2020/11/26 12:39', '2020/09/26 01:39', '2020/04/26 20:39']
  end
  it 'は各投稿に削除リンクが含まれること' do
    tweets = all('.card-footer').map { |tweet| tweet.all('.col').last.text }
    expect(tweets).to eq %w[削除 削除 削除]
  end
end