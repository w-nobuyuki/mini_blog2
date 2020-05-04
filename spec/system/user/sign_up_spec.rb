require 'rails_helper'

RSpec.describe 'User#sign_up', type: :system do
  before do
    visit new_user_registration_path
  end

  it 'はユーザー名、パスワード、パスワード確認を入力してSign upをクリックするとアカウント登録できること' do
    fill_in 'user[name]', with: 'user'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録する'
    expect(page).to have_content 'アカウント登録が完了しました。'
  end

  it 'はユーザー名が空だとアカウント登録できないこと' do
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録する'
    expect(page).to have_content 'ユーザー名を入力してください'
  end

  it 'はユーザー名が既に存在するとアカウント登録できないこと' do
    User.create(name: 'user', password: 'password')
    fill_in 'user[name]', with: 'user'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録する'
    expect(page).to have_content 'ユーザー名はすでに存在します'
  end

  it 'はユーザー名にアルファベット以外が入力されているとアカウント登録できないこと' do
    User.create(name: 'user', password: 'password')
    ['あ', '1', '@', 'a a'].each do |value|
      fill_in 'user[name]', with: value
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button '登録する'
      expect(page).to have_content 'ユーザー名は不正な値です'
    end
  end

  it 'はユーザー名が21文字以上だとアカウント登録できないこと' do
    fill_in 'user[name]', with: Faker::Lorem.characters(number: 21, min_alpha: 21)
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録する'
    expect(page).to have_content 'ユーザー名は20文字以内で入力してください'
  end

  it 'はユーザー名が20文字だとアカウント登録できること' do
    fill_in 'user[name]', with: Faker::Lorem.characters(number: 20, min_alpha: 20)
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録する'
    expect(page).to have_content 'アカウント登録が完了しました。'
  end

  it 'はパスワードが空だとアカウント登録できないこと' do
    fill_in 'user[name]', with: 'user'
    fill_in 'user[password_confirmation]', with: 'password'
    click_button '登録する'
    expect(page).to have_content 'パスワードを入力してください'
  end

  it 'はパスワードが6文字未満だとアカウント登録できないこと' do
    fill_in 'user[name]', with: 'user'
    fill_in 'user[password]', with: 'passw'
    fill_in 'user[password_confirmation]', with: 'passw'
    click_button '登録する'
    expect(page).to have_content 'パスワードは6文字以上で入力してください'
  end

  it 'はパスワードとパスワード確認が一致しないとアカウント登録できないこと' do
    fill_in 'user[name]', with: 'user'
    fill_in 'user[password]', with: 'password'
    fill_in 'user[password_confirmation]', with: 'passpass'
    click_button '登録する'
    expect(page).to have_content 'パスワード確認とパスワードの入力が一致しません'
  end

  it 'はログイン画面へ戻るリンクが存在すること' do
    expect(page).to have_link 'ログイン画面へ戻る', href: new_user_session_path
  end
end