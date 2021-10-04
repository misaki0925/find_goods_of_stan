require 'rails_helper'
RSpec.describe 'Article', type: :system do
  let!(:article) { create(:article, :with_member , :with_images) }
    before do
      article.members.each do |member|
        @name = member.name
      end
    end

  describe '一般ユーザー用記事一覧画面' do
    let!(:other_article) { create(:article, :with_member, :with_images) }
    before do
      other_article.members.each do |member|
        @other_name = member.name
      end
      visit articles_path
    end

    describe '一般ユーザー用記事一覧' do
      it '一般ユーザー用記事が表示される' do
        expect(current_path).to eq(articles_path)
        expect(page).to have_content( article.brand )
        expect(page).to have_content( other_article.brand )
        expect(page).to have_content("#{@name}さん")
        expect(page).to have_content("#{@other_name}さん")
        expect(page).to have_selector("img[src$='test_image1.jpeg']")
      end

      describe '一般ユーザー用記事検索部分' do
        context 'ブランド名で検索' do
          context "複数該当記事がない時" do
            it '検索に成功する' do
              expect(current_path).to eq(articles_path)
              find(".navbar-toggler").click
              fill_in I18n.t('activerecord.attributes.article.brand'),	with: article.brand
              click_on I18n.t('layouts.header.search')
              expect(page).to have_content("#{@name}さん")
              expect(page).to have_content(article.brand)
              expect(page).to_not have_content("#{@other_name}さん")
              expect(page).to_not have_content(other_article.brand)
            end
  
            it '該当する記事なし' do
              expect(current_path).to eq(articles_path)
              find(".navbar-toggler").click
              fill_in I18n.t('activerecord.attributes.article.brand'),	with: "brand_false"
              click_on I18n.t('layouts.header.search')
              expect(page).to_not have_content("brand_false")
              expect(page).to_not have_content(article.brand)
              expect(page).to_not have_content(other_article.brand)
              expect(page).to have_content I18n.t('defaults.no_result') 
            end
          end

          context "複数該当記事がある時" do
            let!(:article_same_brand_1) { create(:article, :same_brand) }
            let!(:article_same_brand_2) { create(:article, :same_brand) }
            it '全ての該当する記事の表示に成功する' do
              expect(current_path).to eq(articles_path)
              find(".navbar-toggler").click
              fill_in I18n.t('activerecord.attributes.article.brand'),	with: article_same_brand_1.brand
              click_on I18n.t('layouts.header.search')
              expect(page).to have_content(article_same_brand_1.brand)
              expect(page).to have_content(article_same_brand_2.brand)
              expect(page).to_not have_content(article.brand)
              expect(page).to_not have_content(other_article.brand)
            end
          end
        end

        context 'メンバーの名前で検索' do
          context "複数該当記事がない時" do
            it '検索に成功する' do
              expect(current_path).to eq(articles_path)
              find(".navbar-toggler").click
              fill_in Member.model_name.human,	with: @name
              click_on I18n.t('layouts.header.search')
              expect(page).to have_content("#{@name}さん")
              expect(page).to have_content(article.brand)
              expect(page).to_not have_content("#{@other_name}さん")
            end

  
            it '該当する記事なし' do
              expect(current_path).to eq(articles_path)
              find(".navbar-toggler").click
              fill_in Member.model_name.human,	with: "#{@name}_fail"
              click_on I18n.t('layouts.header.search')
              expect(page).to_not have_content("#{@name}_failさん")
              expect(page).to_not have_content("#{@name}さん")
              expect(page).to_not have_content("#{@other_name}さん")
              expect(page).to have_content I18n.t('defaults.no_result')
            end
          end

          context "複数該当記事がある時" do
            let!(:article_same_member_1) { create(:article, :same_member) }
            let!(:article_same_member_2) { create(:article) }
            before do
              article_same_member_1.members.each do |member|
                @same_member_name_1 = member.name
              end
              article_same_member_2.members = article_same_member_1.members
              article_same_member_2.members.each do |member|
                @same_member_name_2 = member.name
              end
            end

              it '全ての該当する記事の表示に成功する' do
                expect(current_path).to eq(articles_path)
                find(".navbar-toggler").click
                fill_in Member.model_name.human,	with: @same_member_name_1
                click_on I18n.t('layouts.header.search')
                expect(page).to have_content("#{@same_member_name_1}さん")
                expect(page).to have_content(article_same_member_1.brand)
                expect(page).to have_content("#{@same_member_name_2}さん")
                expect(page).to have_content(article_same_member_2.brand)
                expect(page).to_not have_content("#{@name}}さん")
              end
          end
        end
      end
    end
  end

  describe '一般ユーザー用記事の詳細画面' do
    before do
      visit root_path
      find(".navbar-toggler").click
      click_on I18n.t('layouts.header.item')
      click_link "link_for_#{article.id}_page"
    end

    describe '詳細画面の表示が正常' do
      context 'メンバーが複数いない時' do
        it '表示に成功する' do
          expect(current_path).to eq(article_path(article))
          expect(page).to have_content("#{@name}さん")
          expect(page).to have_content("#{article.brand}")
          expect(page).to have_content("#{article.price}")
          expect(page).to have_content("#{article.item}")
          expect(page).to have_content I18n.t('articles.show.to_twitter')
        end
      end
    end

    describe '詳細画面のTweetへのリンクボタンが正常に動く' do
      it '詳細画面のTweetへのリンクボタンから正常にTwitterへ飛ぶ' do
        expect(page).to have_content I18n.t('articles.show.to_twitter')
        click_on I18n.t('articles.show.to_twitter')
        switch_to_window(windows.last)
        expect(current_url).to eq(article.tweet_url)
      end
    end
  end
end
