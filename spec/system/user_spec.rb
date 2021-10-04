require 'rails_helper'
RSpec.describe 'User', type: :system do
  let(:user) { create(:user, :admin) }
  describe 'ログイン' do
    context 'ログインに成功する' do
      it 'adminログイン画面からログイン' do
        visit admins_login_path
        fill_in I18n.t('activerecord.attributes.member.email'),	with: user.email
        fill_in I18n.t('activerecord.attributes.member.password'),	with: 'password'
        click_button I18n.t('defaults.login')
        expect(page).to have_content I18n.t('flash.login')
        expect(current_path).to eq(admins_articles_path)
      end
    end

    context 'ログインに失敗する' do
      it 'adminログイン画面からログイン失敗' do
        visit admins_login_path
        fill_in I18n.t('activerecord.attributes.member.email'),	with: user.email
        fill_in I18n.t('activerecord.attributes.member.password'),	with: 'miss_password'
        click_button I18n.t('defaults.login')
        expect(page).to have_content I18n.t('flash.not_login')
        expect(current_path).to eq(admins_login_path) 
      end
    end
  end

  describe 'ログイン後' do
    before { login(user) }
    describe "ログアウト" do
      it 'Logoutボタンを押すとログアウトに成功する' do
        visit root_path
        find(".navbar-toggler").click
        click_on I18n.t('layouts.header.logout')
        expect(page).to have_content I18n.t('flash.logout')
        expect(current_path).to eq(admins_login_path) 
      end
    end
  end

  describe "ログインしていない状態でadmin用のページにアクセスする" do
    describe "表示に失敗する" do
      let!(:article) {create(:article)}
      it 'admin用ITEMページ' do
        visit admins_articles_path
        expect(current_path).to eq(admins_login_path) 
        expect(page).to have_content I18n.t('flash.before_login')
      end

      it 'admin用REPORTページ' do
        visit admins_reports_path
        expect(current_path).to eq(admins_login_path) 
        expect(page).to have_content I18n.t('flash.before_login')
      end

      it 'admin用editページ' do
        visit edit_admins_article_path(article.id)
        expect(current_path).to eq(admins_login_path) 
        expect(page).to have_content I18n.t('flash.before_login')
      end 
    end
  end
end
