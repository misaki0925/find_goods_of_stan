require 'rails_helper'
RSpec.describe 'AdiminsArticle', type: :system  do
  describe '管理者ユーザー' do
    let(:user) { create(:user, :admin) }
    before { login(user) }
    let!(:article) {create(:article, :with_member ,:with_images)}
    let!(:other_article) {create(:article, :same_brand)}
    before do
      article.members.each do |member|
        @name = member.name
      end
      @members = []
      other_article.members.each do |member|
        @members.push(member.name)
      end
    end

    describe '管理者用記事一覧画面' do
      describe '管理者用記事の検索部分' do
        context 'ブランド名で検索' do
          it '検索に成功する' do
            expect(current_path).to eq(admins_articles_path)
            find(".navbar-toggler").click
            fill_in I18n.t('activerecord.attributes.article.brand'),	with: other_article.brand
            click_on I18n.t('layouts.header.search')
            expect(page).to_not have_content(article.brand)
            expect(page).to have_content(other_article.brand)
          end

          it '該当する記事なし' do
            expect(current_path).to eq(admins_articles_path)
            find(".navbar-toggler").click
            fill_in I18n.t('activerecord.attributes.article.brand'),	with: "#{other_article.brand}_fail"
            click_on I18n.t('layouts.header.search')
            expect(page).to have_content I18n.t('defaults.no_result')
          end
        end

        context 'メンバーの名前で検索' do
          context "複数該当記事がない時" do
            it '検索に成功する' do
              expect(current_path).to eq(admins_articles_path)
              find(".navbar-toggler").click
              fill_in Member.model_name.human,	with: @name
              click_on I18n.t('layouts.header.search')
              expect(page).to have_content("#{@name}さん")
              expect(page).to_not have_content("#{@members.join("さん")}さん")
            end
  
          it '該当する記事なし' do
            expect(current_path).to eq(admins_articles_path)
            find(".navbar-toggler").click
            fill_in Member.model_name.human,	with: "#{@name}_fail"
            click_on I18n.t('layouts.header.search')
            expect(page).to_not have_content("#{@name}_failさん")
            expect(page).to_not have_content("#{@name}さん")
            expect(page).to_not have_content("#{@members.join("さん")}さん")
            expect(page).to have_content I18n.t('defaults.no_result')
          end
        end
      end
    end
  end

  describe '管理者用記事編集画面' do
    describe '記事を編集できる' do
      before do
        find(".navbar-toggler").click
        click_on I18n.t('layouts.header.admins_item')
        find("#admin_edit_btn_#{article.id}").click
      end
      describe 'メンバー名を正しく編集できる' do
        context "メンバーを一人選択" do
          it 'メンバー名の編集に成功する' do
            expect(page).to have_checked_field("#{@name.first}")
            expect(page).to_not have_checked_field("#{@members.first}")
            uncheck("article_member_ids_#{article.members.first.id}")
            check("article_member_ids_#{other_article.members.first.id}")
            click_button I18n.t('admins.articles.edit.update')
            expect(page).to have_content(I18n.t('flash.updated'))
            expect(current_path).to eq(admins_articles_path)
            expect(page).to have_content("#{@members.first}さん")
          end
        end

        context 'メンバーを複数選択' do
          it 'メンバー名の編集に成功する' do
            expect(page).to have_checked_field("#{@name.first}")
            expect(page).to_not have_checked_field("#{@members.first}")
            expect(page).to_not have_checked_field("#{@members.last}")
            uncheck("article_member_ids_#{article.members.first.id}")
            check("article_member_ids_#{other_article.members.first.id}")
            check("article_member_ids_#{other_article.members.last.id}")
            click_button I18n.t('admins.articles.edit.update')
            expect(page).to have_content I18n.t('flash.updated')
            expect(current_path).to eq(admins_articles_path)
            expect{
              article.reload
            }.to change{article.members}.from(article.members).to(other_article.members)
          end
        end
      end
        
      describe "ブランド名とアイテム名の編集" do
        it 'ブランド名とアイテム名を正しく編集できる' do
          fill_in "article[brand]",	with: 'change_brand' 
          fill_in "article[item]",	with: 'change_item' 
          expect{
            click_button I18n.t('admins.articles.edit.update')
            sleep 0.5
            }.to change {article.reload.brand}.from(article.brand).to('change_brand').and change {article.reload.item}.from(article.item).to('change_item')
          expect(page).to have_content I18n.t('flash.updated')
          expect(current_path).to eq(admins_articles_path)
        end
      end

      describe "tweet_urlの編集" do
        let!(:article_with_url) { create(:article, :with_tweet_url) }
        before do
          find(".navbar-toggler").click
          click_on I18n.t('layouts.header.admins_item')
          find("#admin_edit_btn_#{article_with_url.id}").click
        end
          
        context 'tweet_urlが一意になっている' do
          it 'tweet_urlの更新に成功する' do
          fill_in 'article[tweet_url]',	with: "https://twitter.com/2jkhs6/status/000"
          expect { 
            click_button I18n.t('admins.articles.edit.update')
            sleep 0.5
          }.to change { article_with_url.reload.tweet_url }.from("https://twitter.com/2jkhs6/status/1397176868780986370").to("https://twitter.com/2jkhs6/status/000")
          expect(page).to have_content I18n.t('flash.updated')
          expect(current_path).to eq(admins_articles_path)
          end
        end

        context "tweet_urlが一意になっていない" do
          it 'tweet_urlの更新に失敗する' do
            fill_in 'article[tweet_url]',	with: other_article.tweet_url
            expect { 
              click_button I18n.t('admins.articles.edit.update')
              sleep 0.5
            }.not_to change { article_with_url.reload.tweet_url }
            expect(page).to have_content I18n.t('flash.not_updated')
            expect(current_path).to eq(admins_article_path(article_with_url.id))
          end
        end
      end

      describe '画像の編集' do
        it '画像を削除することができる' do
          check("article_image_ids_#{article.images.first.id}")
          expect{ 
            click_on I18n.t('admins.articles.edit.update')
            sleep 0.5
            }.to change { article.images.count}.by(-1)
        end

        it '画像を選択することができる' do
          attach_file "article[images][]", "spec/fixtures/test_image3.jpeg"
          expect{ 
            click_on I18n.t('admins.articles.edit.update')
            sleep 0.5
          }.to change { article.images.count }.by(+1)
          expect(current_path).to eq(admins_articles_path)
          find("#admin_edit_btn_#{article.id}").click
          expect(page).to have_selector("img[src$='test_image3.jpeg']")
        end
      end

      describe '記事を削除できる' do
        it '選択した記事の削除に成功する' do
          expect(current_path).to eq(edit_admins_article_path(article.id))
          expect{
            page.accept_confirm I18n.t('defaults.confirm_delete') do
              click_on I18n.t('defaults.delete')
            end
            sleep 0.5
          }.to change{Article.count}.by(-1)
          expect(page).to have_content I18n.t('flash.deleted')
          expect(current_path).to eq(admins_articles_path)
          end
        end
      end
    end
  end
end
