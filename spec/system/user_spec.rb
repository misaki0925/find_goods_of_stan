require 'rails_helper'
RSpec.describe 'User', type: :system do
  let(:user) { create(:user, :admin) }
  describe 'ログイン' do
    context 'ログインに成功する' do
      it 'adminログイン画面からログイン' do
        visit admins_login_path
        fill_in "メールアドレス",	with: user.email
        fill_in "パスワード",	with: 'password'
        click_button "ログイン"
        expect(page).to have_content 'ログインしました'  
        expect(current_path).to eq(admins_articles_path)
      end
    end

    context 'ログインに失敗する' do
      it 'adminログイン画面からログイン失敗' do
        visit admins_login_path
        fill_in "メールアドレス",	with: user.email
        fill_in "パスワード",	with: 'miss_password'
        click_button "ログイン"
        expect(page).to have_content 'ログインできません' 
        expect(current_path).to eq(admins_login_path) 
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }
    describe "ログアウト" do
      it 'Logoutボタンを押すとログアウトに成功する' do
        visit articles_path
        find(".navbar-toggler").click
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました' 
        expect(current_path).to eq(admins_login_path) 
      end
    end
  end
end
