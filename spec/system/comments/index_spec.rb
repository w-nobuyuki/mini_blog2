require 'rails_helper'

RSpec.describe 'Comments#index', type: :system, js: true do
  before do
    @first_user = User.create(name: 'first', email: 'first@test.co.jp', password: 'password')
    @second_user = User.create(name: 'second', email: 'second@test.co.jp', password: 'password')
    @tweet = @first_user.tweets.create(body: 'tweet1', created_at: '2020/04/26 20:39')
    @tweet.comments.create(user: @first_user, body: '最初のコメント', created_at: '2020/04/26 20:39')
    @tweet.comments.create(user: @second_user, body: '２つ目のコメント', created_at: '2020/05/26 20:39')
    visit new_user_session_path
    fill_in 'user[name]',	with: 'first'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
    visit root_path
    within first('.card') do
      click_link 'コメント', href: tweet_comments_path(@tweet)
    end
  end

  it 'は各コメントにユーザ名が含まれること' do
    within('#comments') do
      comments = all('li.list-group-item').map { |comment| comment.first('.col-auto').text }
      expect(comments[0..1]).to eq %w[first second]
    end
  end

  it 'は各コメントに本文が含まれること' do
    within('#comments') do
      comments = all('li.list-group-item p').map(&:text)
      expect([comments[0], comments[2]]).to eq %w[最初のコメント ２つ目のコメント]
    end
  end

  it 'は各コメントにコメント日時（YYYY/MM/DD hh:mm）が含まれること' do
    within('#comments') do
      comments = all('li.list-group-item p').map(&:text)
      expect([comments[1], comments[3]]).to eq ['2020/04/26 20:39', '2020/05/26 20:39']
    end
  end

  it 'は自身のコメントにのみ削除リンクが含まれること' do
    within('#comments') do
      comments = all('li.list-group-item').map { |comment| comment.all('.col-auto').last.text }
      expect(comments[0..1]).to eq ['削除', '']
    end
  end

  it 'は自身のコメントを削除できること' do
    within first('#comments .list-group-item') do
      accept_confirm do
        click_link '削除'
      end
    end
    expect(page).to have_content 'コメントを削除しました。'
  end

  it 'はユーザー名のリンクからそのユーザーのページに飛べること' do
    within('#comments') do
      click_link 'second'
      expect(current_path).to eq user_path(@second_user)
    end
  end
end
