require 'rails_helper'

RSpec.describe 'AdiminsArticle', type: :system  do
  describe '管理者ユーザー' do
    let(:user) { create(:user, :admin) }
    before { login(user) }
    let!(:article) { create(:article, :with_tweet_url, :with_images) }
    let!(:other_article) { create(:article, :with_members) }
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
      describe '管理者用記事一覧画面が正常に表示されている' do
        before do
          visit root_path
          click_on 'Articles'
        end
        describe '表示内容が正しく表示される' do
          it '記事内容が表示される' do
            expect(current_path).to  eq(admins_articles_path)
            expect(page).to have_content("#{@name}さん")
            expect(page).to have_content(article.brand)
            expect(page).to have_content(article.price)
            expect(page).to have_content(article.item)
            expect(page).to have_content("#{@members.join("さん")}さん")
            expect(page).to have_content(other_article.brand)
            expect(page).to have_content(other_article.price)
            expect(page).to have_content(other_article.item)
            expect(page.all('.admin_show_btn').count).to eq 2
            expect(page.all('.admin_edit_btn').count).to eq 2
          end

          describe '画像枚数ついての表示部分' do
            context '画像がない' do
              it '画像枚数が表示される' do
                expect(current_path).to  eq(admins_articles_path)
                  tds = all('tr')[1].all('td')
                  expect(tds[4]).to have_content('0枚')
              end
            end

            context '画像がある' do
              it '画像枚数が2枚と表示される' do
                expect(current_path).to  eq(admins_articles_path)
                  tds = all('tr')[2].all('td')
                  expect(tds[4]).to have_content('1枚')
              end
            end
          end
        end

        it '詳細画面への遷移が成功する' do
          find("#admin_show_btn_#{article.id}").click
          expect(current_path).to eq(article_path(article))
        end

        describe '管理者用記事の検索部分' do
          context 'ブランド名で検索' do
            context "複数該当記事がない時" do
              it '検索に成功する' do
                expect(current_path).to eq(admins_articles_path)
                fill_in "ブランド",	with: article.brand
                click_on '検索'
                expect(current_path).to eq(search_admins_articles_path)
                expect(page).to have_content("#{@name}さん")
                expect(page).to have_content(article.brand)
                expect(page).to_not have_content("#{@members.join("さん")}さん")
                expect(page).to_not have_content(other_article.brand)
              end
    
              it '該当する記事なし' do
                expect(current_path).to eq(admins_articles_path)
                fill_in "ブランド",	with: "#{article.brand}_fail"
                click_on '検索'
                expect(current_path).to eq(search_admins_articles_path)
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
                expect(current_path).to eq(admins_articles_path)
                fill_in "ブランド",	with: article_same_brand_1.brand
                click_on '検索'
                expect(current_path).to eq(search_admins_articles_path)
                expect(page).to have_content(article_same_brand_1.brand)
                expect(page).to have_content(article_same_brand_2.brand)
                expect(page).to_not have_content(article.brand)
              end
            end
          end
  
          context 'メンバーの名前で検索' do
            context "複数該当記事がない時" do
              it '検索に成功する' do
                expect(current_path).to eq(admins_articles_path)
                fill_in "メンバー",	with: @name
                click_on '検索'
                expect(current_path).to eq(search_admins_articles_path)
                expect(page).to have_content("#{@name}さん")
                expect(page).to have_content(article.brand)
                expect(page).to_not have_content("#{@members.join("さん")}さん")
              end
    
              it '該当する記事なし' do
                expect(current_path).to eq(admins_articles_path)
                fill_in "メンバー",	with: "#{@name}_fail"
                click_on '検索'
                expect(current_path).to eq(search_admins_articles_path)
                expect(page).to_not have_content("#{@name}_failさん")
                expect(page).to_not have_content("#{@name}さん")
                expect(page).to_not have_content("#{@members.join("さん")}さん")
                expect(page).to have_content('該当する記事がありません') 
              end
            end
  
            # context "複数該当記事がある時" do
            #   let!(:article_same_member_1) { create(:article, :same_member) }
            #   let!(:article_same_member_2) { create(:article)}
            #   before do
            #     article_same_member_1.members.each do |member|
            #       @same_member_name_1 = member.name
            #     end
            #     article_same_member_2.members << article_same_member_1.members
            #     article_same_member_2.members.each do |member|
            #       @same_member_name_2 = member.name
            #     end
            #   end

            #   context "どれかしらの記事に複数のメンバー名が表示されていない時" do
            #     it '全ての該当する記事の表示に成功する' do
            #       expect(current_path).to eq(admins_articles_path)
            #       fill_in "メンバー",	with: @same_member_name_1
            #       click_on '検索'
            #       expect(current_path).to eq(search_admins_articles_path)
            #       expect(page).to have_content("#{@same_member_name_1}さん")
            #       expect(page).to have_content("#{@same_member_name_2}さん")
            #       expect(page).to_not have_content("#{@name}}さん")
            #     end
            #   end ここエラー
  
              context "どれかしらの記事に複数のメンバー名が表示されている時" do
                it '該当する記事の表示に成功する' do
                expect(current_path).to eq(admins_articles_path)
                  fill_in "メンバー",	with: @members.last
                  click_on '検索'
                  expect(current_path).to eq(search_admins_articles_path)
                  expect(page).to have_content("#{@members.join("さん")}さん")
                  expect(page).to have_content("#{@same_member_name_1}さん")
                  expect(page).to have_content("#{@same_member_name_2}さん")
                  expect(page).to_not have_content("#{@name}}さん")
                end
              end
            end
          end
        end
      end
    end

    describe '管理者用記事編集画面' do
      before do
        visit root_path
        click_on 'Articles'
      end

      it '編集画面への遷移が成功する' do
        expect(current_path).to  eq(admins_articles_path)
        find("#admin_edit_btn_#{article.id}").click
        expect(current_path).to eq(edit_admins_article_path(article))
      end

      describe '記事を編集できる' do
        before do
          find("#admin_edit_btn_#{article.id}").click
        end

        describe 'メンバー名を正しく編集できる' do
          context "メンバーを一人選択" do
            it 'メンバー名編の編集に成功する' do
              expect(page).to have_checked_field("#{@name.first}")
              expect(page).to_not have_checked_field("#{@members.first}")
              uncheck("article_member_ids_#{article.members.first.id}")
              check("article_member_ids_#{other_article.members.first.id}")
              click_button '更新する'
              expect(page).to have_content('記事を更新しました')
              expect(current_path).to eq(article_path(article.id))
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
              click_button '更新する'
              expect(page).to have_content('記事を更新しました')
              expect(current_path).to eq(article_path(article.id))
              expect{
                article.reload
              }.to change{article.members}.from(article.members).to(other_article.members)
            end
          end
        end
        
        it 'ブランド名を正しく編集できる' do
          expect(page).to have_content('<brand>')
          fill_in 'article[brand]',	with: 'change_brand' 
          expect{
            click_button '更新する'
            sleep 0.5
          }.to change {article.reload.brand}.from(article.brand).to('change_brand')
          expect(page).to have_content('記事を更新しました')
          expect(current_path).to eq(article_path(article.id))
        end
        
        it 'アイテム名を正しく編集できる' do
          expect(page).to have_content('<item>')
          fill_in 'article[item]',	with: 'change_item' 
          expect{
            click_button '更新する'
            sleep 0.5
          }.to change {article.reload.item}.from(article.item).to('change_item')
          expect(page).to have_content('記事を更新しました')
          expect(current_path).to eq(article_path(article.id))
        end

        describe 'tweet_urlは一意でなければならない' do
          context 'tweet_urlが一意になっている' do
            it 'tweet_urlの更新に成功する' do
            expect(page).to have_content('<Twitterへのurl>')
            expect(article.tweet_url).to eq("https://twitter.com/2jkhs6/status/1397176868780986370")
            fill_in 'article[tweet_url]',	with: "https://72"
            expect { 
              click_button '更新する'
              sleep 0.5
            }.to change { article.reload.tweet_url }.from("https://twitter.com/2jkhs6/status/1397176868780986370").to("https://72")
            expect(page).to have_content('記事を更新しました')
            expect(current_path).to eq(article_path(article.id))
            end
          end

          context 'tweet_urlが一意になっていない' do
            let!(:article_tweet_url) { create(:article, :with_tweet_url_2) }
            it 'tweet_urlの更新に失敗する' do
              expect(page).to have_content('<Twitterへのurl>')
              expect(article.tweet_url).to eq("https://twitter.com/2jkhs6/status/1397176868780986370")
              fill_in 'article[tweet_url]',	with: article_tweet_url.tweet_url
              expect { 
                click_button '更新する'
                sleep 0.5
              }.not_to change { article.reload.tweet_url }
              expect(page).to have_content('記事を更新できませんでした。')
              expect(current_path).to eq(admins_article_path(article.id))
            end
          end
        end

        describe '画像の編集' do
          it '画像を削除することができる' do
            expect(page).to_not have_checked_field( "#article_image_ids_#{article.images.first.id}")
            check("article_image_ids_#{article.images.first.id}")
            expect{ 
              click_on '更新する'
              sleep 0.5
                }.to change { article.images.count }.by(-1)
          end

          it '画像を選択することができる' do
            attach_file "article[images][]", "spec/fixtures/test_image3.jpeg"
            expect{ 
              click_on '更新する'
              sleep 0.5
                }.to change { article.images.count }.by(+1)
            expect(current_path).to eq(article_path(article.id))
            expect(page).to have_selector("img[src$='test_image3.jpeg']")
          end
        end
      end

      describe '記事を削除できる' do
        it '選択した記事の削除に成功する' do
          find("#admin_edit_btn_#{article.id}").click
          expect(current_path).to eq(edit_admins_article_path(article.id))
          expect{ 
          click_on '削除'
          sleep 0.5
            }.to change { Article.count }.by(-1)
            expect(page).to have_content('削除しました')
        end
      end
    end
  end
end
