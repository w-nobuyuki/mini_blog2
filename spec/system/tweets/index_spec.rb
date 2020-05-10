require 'rails_helper'

RSpec.describe 'Tweets#index', type: :system, js: true do
  before do
    @first_user = User.create(name: 'first', password: 'password')
    @second_user = User.create(name: 'second', password: 'password')
    @first_user.tweets.create(body: 'tweet1', created_at: '2020/04/26 20:39')
    @first_user.tweets.create(body: 'tweet2', created_at: '2020/09/26 1:39')
    @tweet3 = @second_user.tweets.create(body: 'tweet3', created_at: '2020/11/26 12:39')
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
    tweets = all('.card-title').map { |tweet| tweet.first('.col-auto').text }
    expect(tweets).to eq %w[second first first]
  end

  it 'は各投稿に本文が含まれること' do
    tweets = all('.card-body').map { |tweet| tweet.first('.card-text').text }
    expect(tweets).to eq %w[tweet3 tweet2 tweet1]
  end

  it 'は各投稿に投稿日時（YYYY/MM/DD hh:mm）が含まれること' do
    tweets = all('.card-body').map { |tweet| tweet.first('small').text }
    expect(tweets).to eq ['2020/11/26 12:39', '2020/09/26 01:39', '2020/04/26 20:39']
  end

  it 'は自身の投稿に削除リンクが含まれること' do
    tweets = all('.card-title').map { |tweet| tweet.all('.col-auto').last.text }
    expect(tweets[1..2]).to eq %w[削除 削除]
  end

  it 'は自身の投稿を削除できること' do
    within all('.card').last do
      accept_confirm do
        click_link '削除'
      end
    end
    expect(page).to have_content 'つぶやきを削除しました。'
  end

  it 'はフォローしているユーザーの投稿がフォローユーザーのタイムラインで表示されること' do
    @first_user.follows.create(follow_user_id: @second_user.id)
    visit root_path
    click_link 'フォローユーザーのタイムライン'
    expect(page).to have_css '#timeline-follow-users.show'
    tweets = all('.card-title').map { |tweet| tweet.first('.col-auto').text }
    expect(tweets).to eq %w[second]
  end

  it 'はフォローしていないユーザーの投稿がフォローユーザーのタイムラインで表示されないこと' do
    click_link 'フォローユーザーのタイムライン'
    expect(page).to have_css '#timeline-follow-users.show'
    tweets = all('.card-title').map { |tweet| tweet.first('.col-auto').text }
    expect(tweets).to_not include 'second'
  end

  it 'はユーザー名のリンクからそのユーザーのページに飛べること' do
    click_link 'second'
    expect(current_path).to eq user_path(@second_user)
  end

  it 'はいいねをするといいねボタンの背景色が青色に変わること' do
    within first('.card') do
      click_link 'いいね！', href: like_tweet_path(@tweet3)
      expect(page).to have_css('a.btn.btn-primary.btn-sm')
    end
  end

  it 'はいいねを解除するといいねボタンの背景色が透明に変わること' do
    within first('.card') do
      click_link 'いいね！', href: like_tweet_path(@tweet3)
      click_link 'いいね！', href: unlike_tweet_path(@tweet3)
      expect(page).to have_css('a.btn.btn-outline-primary.btn-sm')
    end
  end

  it 'はいいねが0件の状態でいいねボタンを押すといいねの件数が1件で表示されること' do
    within first('.card') do
      click_link 'いいね！', href: like_tweet_path(@tweet3)
      expect(page).to have_link '1 いいね', href: tweet_path(@tweet3)
    end
  end

  it 'はいいねが1件の状態でいいねボタンを押すといいねの件数が2件で表示されること' do
    @tweet3.likes.create(user_id: @second_user.id)
    visit root_path
    within first('.card') do
      click_link 'いいね！', href: like_tweet_path(@tweet3)
      expect(page).to have_link '2 いいね', href: tweet_path(@tweet3)
    end
  end

  it 'はいいねの件数が0件になるといいねの件数表示がなくなること' do
    within first('.card') do
      click_link 'いいね！', href: like_tweet_path(@tweet3)
      expect(page).to have_link '1 いいね', href: tweet_path(@tweet3)
      click_link 'いいね！', href: unlike_tweet_path(@tweet3)
      expect(page).to_not have_link '1 いいね', href: tweet_path(@tweet3)
    end
  end

  it 'はいいねの件数をクリックするといいねをしたユーザーの一覧が表示されること' do
    @tweet3.likes.create(user_id: @second_user.id)
    click_link 'いいね！', href: like_tweet_path(@tweet3)
    click_link '2 いいね', href: tweet_path(@tweet3)
    within('.modal') do
      expect(page).to have_link 'first', href: user_path(@first_user)
      expect(page).to have_link 'second', href: user_path(@second_user)
    end
  end

  it 'はいいねをしたユーザーの一覧からユーザーのページへ飛べること' do
    click_link 'いいね！', href: like_tweet_path(@tweet3)
    click_link '1 いいね', href: tweet_path(@tweet3)
    within('.modal') do
      click_link 'first', href: user_path(@first_user)
    end
    expect(current_path).to eq user_path(@first_user)
  end

  it 'はいいねをしたユーザーの一覧は閉じるボタンで閉じること' do
    click_link 'いいね！', href: like_tweet_path(@tweet3)
    click_link '1 いいね', href: tweet_path(@tweet3)
    within('.modal') do
      click_button '閉じる'
    end
    expect(page).to_not have_content 'いいね！をしたユーザー'
  end

  it 'は各投稿にコメントの送信画面へのリンクが存在すること' do
    tweets = all('.card').map { |tweet| tweet.find_link('コメント').text }
    expect(tweets).to eq %w[コメント コメント コメント]
  end

  it 'はコメントボタンを押すとコメント送信画面（モーダル）が開くこと' do
    within first('.card') do
      click_link 'コメント', href: tweet_comments_path(@tweet3)
    end
    expect(page).to have_css '#comments.modal.show'
  end
end
