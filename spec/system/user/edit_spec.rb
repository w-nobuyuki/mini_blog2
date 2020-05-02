RSpec.describe 'User#edit', type: :system do
  before do
    User.create(
      name: 'user',
      password: 'password',
      profile: 'プロフィール\nこれはプロフィールです。',
      blog_url: 'https://google.co.jp'
    )
    visit new_user_session_path
    fill_in 'user[name]',	with: 'user'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
    visit edit_user_registration_path
  end

  it '現在のパスワードを入力して更新するボタンをクリックするとユーザー情報を更新できること' do
    fill_in 'user[current_password]', with: 'password'
    click_button '更新する'
    expect(page).to have_content 'アカウント情報を変更しました。'
  end

  it '現在のパスワードを入力しないとユーザー情報を更新できないこと' do
    click_button '更新する'
    expect(page).to have_content '現在のパスワードを入力してください'
  end

  it 'ユーザー名には既存の値が表示されること' do
    expect(find_field('user[name]').value).to eq 'user'
  end

  it 'プロフィールには既存の値が表示されること' do
    expect(find_field('user[profile]').value).to eq 'プロフィール\nこれはプロフィールです。'
  end

  it 'ブログURLには既存の値が表示されること' do
    expect(find_field('user[blog_url]').value).to eq 'https://google.co.jp'
  end
end