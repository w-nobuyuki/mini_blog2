RSpec.describe "Users#show", type: :system do
  before do
    user = User.create(
      name: 'user',
      password: 'password',
      profile: 'プロフィール\nこれはプロフィールです。',
      blog_url: 'https://google.co.jp'
    )
    visit new_user_session_path
    fill_in 'user[name]',	with: 'user'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
    visit user_path(user)
  end

  it 'ユーザー名が表示されていること' do
    expect(page).to have_content 'user'
  end

  it 'プロフィールが表示されていること' do
    expect(page).to have_content 'プロフィール\nこれはプロフィールです。'
  end

  it 'ブログURLが表示されていること' do
    expect(page).to have_content 'https://google.co.jp'
  end

  it 'トップページへ戻るリンクからトップページへ画面遷移できること' do
    click_link 'トップページへ戻る'
    expect(current_path).to eq root_path
  end
end
