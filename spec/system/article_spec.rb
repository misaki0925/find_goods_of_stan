require 'rails_helper'

RSpec.describe 'Article', type: :system do
  let!(:article) { create(:article, :with_member) }
  let!(:article_with_members) { create(:article, :with_member)}
    before do
      article.members.each do |member|
        @name = member.name
      end
      @members = []
      article_with_members.members.each do |member|
        @members.push(member.name)
      end
    end

  describe '一般ユーザー用記事一覧画面' do
    let!(:other_article) { create(:article, :with_member) }
    before do
      other_article.members.each do |member|
        @other_name = member.name
      end
      visit root_path
      click_on '私物一覧はこちらから'
    end
    describe '一般ユーザー用記事一覧' do
      it '一般ユーザー用記事が表示される' do
        expect(current_path).to eq(articles_path)
        expect(page).to have_content( article.brand )
        expect(page).to have_content( other_article.brand )
        expect(page).to have_content("#{@name}さん")
        expect(page).to have_content("#{@other_name}さん")
        # expect(page).to have_content("")imageが表示されているかどうか
        expect(page).to have_button( '詳細ページへ' )
        expect(Article.count).to eq 3
      end

      describe '一般ユーザー用記事の検索部分' do
        context 'ブランド名で検索' do
          context "複数該当記事がない時" do
            it '検索に成功する' do
              expect(current_path).to eq(articles_path)
              fill_in "ブランド",	with: article.brand
              click_on '検索'
              expect(current_path).to eq(articles_path)
              expect(page).to have_content("#{@name}さん")
              expect(page).to have_content(article.brand)
              expect(page).to_not have_content("#{@other_name}さん")
              expect(page).to_not have_content(other_article.brand)
              expect(page).to have_button( '詳細ページへ' )
            end
  
            it '該当する記事なし' do
              expect(current_path).to eq(articles_path)
              fill_in "ブランド",	with: "#{article.brand}_fail"
              click_on '検索'
              expect(current_path).to eq(articles_path)
              expect(page).to_not have_content("#{article.brand}_fail")
              expect(page).to_not have_content(article.brand)
              expect(page).to_not have_content(other_article.brand)
              expect(page).to have_content('該当する記事がありません') 
            end
          end

          context "複数該当記事がある時" do
            let!(:article_same_brand_1) { create(:article, :same_brand) }
            let!(:article_same_brand_2) { create(:article, :same_brand) }
            it '全ての該当する記事の表示に成功する' do
              expect(current_path).to eq(articles_path)
              fill_in "ブランド",	with: article_same_brand_1.brand
              click_on '検索'
              expect(current_path).to eq(articles_path)
              expect(page).to have_content(article_same_brand_1.brand)
              expect(page).to have_content(article_same_brand_2.brand)
              expect(page).to_not have_content(article.brand)
              expect(page).to_not have_content(other_article.brand)
              expect(page).to have_button( '詳細ページへ' )
            end
          end
        end

        context 'メンバーの名前で検索' do
          context "複数該当記事がない時" do
            it '検索に成功する' do
              expect(current_path).to eq(articles_path)
              fill_in "メンバー",	with: @name
              click_on '検索'
              expect(current_path).to eq(articles_path)
              expect(page).to have_content("#{@name}さん")
              expect(page).to have_content(article.brand)
              expect(page).to_not have_content("#{@other_name}さん")
              expect(page).to have_button( '詳細ページへ' )
            end
  
            it '該当する記事なし' do
              expect(current_path).to eq(articles_path)
              fill_in "メンバー",	with: "#{@name}_fail"
              click_on '検索'
              expect(current_path).to eq(articles_path)
              expect(page).to_not have_content("#{@name}_failさん")
              expect(page).to_not have_content("#{@name}さん")
              expect(page).to_not have_content("#{@other_name}さん")
              expect(page).to have_content('該当する記事がありません') 
            end
          end

          context "複数該当記事がある時" do
            let!(:article_same_member_1) { create(:article, :same_member) }
            let!(:article_same_member_2) { create(:article, :same_member) }
            before do
              article_same_member_1.members.each do |member|
                @same_member_name_1 = member.name
              end
              article_same_member_2.members.each do |member|
                @same_member_name_2 = member.name
              end
            end
            context "どれかしらの記事に複数のメンバー名が表示されていない時" do
              it '全ての該当する記事の表示に成功する' do
                expect(current_path).to eq(articles_path)
                fill_in "メンバー",	with: @same_member_name_1
                click_on '検索'
                expect(current_path).to eq(articles_path)
                expect(page).to have_content("#{@same_member_name_1}さん")
                expect(page).to have_content("#{@same_member_name_2}さん")
                expect(page).to_not have_content("#{@name}}さん")
                expect(page).to have_button( '詳細ページへ' )
              end
            end


            context "どれかしらの記事に複数のメンバー名が表示されている時" do
              it '該当する記事の表示に成功する' do
                expect(current_path).to eq(articles_path)
                fill_in "メンバー",	with: @members.last
                click_on '検索'
                expect(current_path).to eq(articles_path)
                expect(page).to have_content("#{@members.join("さん")}さん")
                expect(page).to have_content("#{@same_member_name_1}さん")
                expect(page).to have_content("#{@same_member_name_2}さん")
                expect(page).to_not have_content("#{@name}}さん")
                expect(page).to have_button( '詳細ページへ' )
              end
            end
          end
        end
      end
    end
  end

  describe '一般ユーザー用記事の詳細画面' do
      let!(:article_with_tweet_url) { create(:article, :with_tweet_url)}
    before do
      visit root_path
      click_on '私物一覧はこちらから'
    end
    describe '詳細画面の表示が正常' do
      context 'メンバーが複数いない時' do
        it '表示に成功する' do
          find("#btn_#{article.id}").click
          expect(current_path).to eq(article_path(article))
          expect(page).to have_content("#{@name}さん")
          expect(page).to have_content("<Brand>#{article.brand}")
          expect(page).to have_content("<Price> #{article.price}")
          expect(page).to have_content("<Item> #{article.item}")
          expect(page).to have_content("詳しくはTweetをご覧ください")
        end
    end

    context 'メンバーが複数いる時' do
      it '表示に成功する' do
      find("#btn_#{article_with_members.id}").click
      expect(current_path).to eq(article_path(article_with_members))
      expect(page).to have_content("#{@members.join("さん")}さん")
      expect(page).to have_content("<Brand>#{article_with_members.brand}")
      expect(page).to have_content("<Price> #{article_with_members.price}")
      expect(page).to have_content("<Item> #{article_with_members.item}")
      expect(page).to have_content("詳しくはTweetをご覧ください")
      end
    end
  end

  describe '詳細画面のTweetへのリンクボタンが正常に動く' do
    it '詳細画面のTweetへのリンクボタンから正常にTwitterへ飛ぶ' do
      find("#btn_#{article_with_tweet_url.id}").click
      expect(current_path).to eq(article_path(article_with_tweet_url))
      click_on '詳しくはTweetをご覧ください'
      switch_to_window(windows.last)
      expect(current_url).to eq(article_with_tweet_url.tweet_url)
    end
  end
  end
end

