require 'rails_helper'

RSpec.describe 'User#sign_in', type: :system do
  before do
    User.create(name: 'user', password: 'password')
    visit new_user_session_path
  end

  it 'はユーザー名とパスワードを入力するとログインできること' do
    fill_in 'user[name]',	with: 'user'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
  end

  it 'は誤ったユーザー名ではログインできないこと' do
    fill_in 'user[name]',	with: 'admin'
    fill_in 'user[password]',	with: 'password'
    click_button 'ログイン'
    expect(page).to have_content 'ユーザー名またはパスワードが違います。'
  end

  it 'は誤ったパスワードではログインできないこと' do
    fill_in 'user[name]',	with: 'user'
    fill_in 'user[password]',	with: 'passpass'
    click_button 'ログイン'
    expect(page).to have_content 'ユーザー名またはパスワードが違います。'
  end

  it 'はアカウント登録画面へのリンクが存在すること' do
    expect(page).to have_link 'アカウントを登録する', href: new_user_registration_path
  end
end