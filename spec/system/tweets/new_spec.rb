require 'rails_helper'

RSpec.describe 'Tweets#new', type: :system do
  before do
    visit new_tweet_path
  end

  it 'は空文字での投稿はできないこと' do
    click_button '投稿する'
    error_message = find('.invalid-feedback').text
    expect(error_message).to eq "Body can't be blank"
  end

  it 'は140文字を超える投稿はできないこと' do
    fill_in 'tweet[body]',	with: Faker::Lorem.characters(number: 141)
    click_button '投稿する'
    error_message = find('.invalid-feedback').text
    expect(error_message).to eq 'Body is too long (maximum is 140 characters)'
  end

  it 'は投稿に成功したら全体タイムラインに画面遷移すること' do
    fill_in 'tweet[body]',	with: 'つぶやき'
    click_button '投稿する'
    expect(page).to have_content 'つぶやきを投稿しました。'
  end

  it 'は全体タイムラインへ戻るリンクが存在すること' do
    click_link '戻る'
    expect(current_path).to eq(root_path)
  end
end