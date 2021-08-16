require 'rails_helper'

RSpec.describe 'AdiminsArticle', type: :system  do
  describe '管理者ユーザー' do
    let(:user) { create(:user, :admin) }
    before { login(user) }
    let!(:article) { create(:article, :with_tweet_url) }
    before do
      article.members.each do |member|
        @name = member.name
      end
    end

    describe '管理者用記事一覧画面' do
      describe '管理者用記事一覧画面が正常に表示されている' do
        let!(:other_article) { create(:article, :with_member) }
        let!(:article_no_tweet_url) {create(:article, :no_tweet_url)}
        # let!(:article_no_tweet_url) {create(:article, :no_tweet_url)}ここで０枚の記事を作成
        before do
          other_article.members.each do |member|
            @other_name = member.name
          end
          visit root_path
          click_on 'Admin/Index'
        end
        describe '表示内容が正しく表示される' do
          xit '記事内容が表示される' do
            expect(current_path).to  eq(admins_articles_path)
            expect(page).to have_content(@name)
            expect(page).to have_content(article.brand)
            expect(page).to have_content(article.price)
            expect(page).to have_content(article.item)
            expect(page.all('.admin_show_btn').count).to eq 2
            expect(page.all('.admin_edit_btn').count).to eq 2
          end

          describe 'tweet_urlについての表示部分' do
            context 'tweet_urlがある' do
              xit 'ありが表示される' do
                expect(current_path).to  eq(admins_articles_path)
                tds = all('tr')[3].all('td')
                expect(tds[4]).to have_content('あり')  
              end
            end

            context 'tweet_urlがない' do
              xit 'なしが表示される' do
                expect(current_path).to  eq(admins_articles_path)
                tds = all('tr')[1].all('td')
                expect(tds[4]).to have_content('なし')  
              end
            end
          end

          describe '画像枚数ついての表示部分' do
            #ここの下のcontextはactiverecordが成功したら書き足す原型はこのままで大丈夫
            context '画像1枚以上ある' do
              it '画像枚数が表示される' do
                expect(current_path).to  eq(admins_articles_path)
                  tds = all('tr')[1].all('td')
                  expect(tds[4]).to have_content('なし')
              end
            end

            context '画像がない' do
              it '画像枚数が0枚と表示される' do
                expect(current_path).to  eq(admins_articles_path)
                  tds = all('tr')[1].all('td')
                  expect(tds[5]).to have_content('なし')
              end
            end
            

            
          end
          
        end
        
        

        xit '詳細画面への遷移は成功する' do
          expect(current_path).to  eq(admins_articles_path)
          find("#admin_show_btn_#{article.id}").click
          expect(current_path).to eq(article_path(article))
        end
      end
    end

    describe '管理者用記事編集画面' do
      before do
        visit root_path
        click_on 'Admin/Index'
      end

      xit '編集画面への遷移は成功する' do
        expect(current_path).to  eq(admins_articles_path)
        find("#admin_edit_btn_#{article.id}").click
        expect(current_path).to eq(edit_admins_article_path(article))
      end

      describe '記事を編集できる' do
        let!(:other_article) { create(:article, :with_member) }
          before do
            other_article.members.each do |member|
              @other_name = member.name
            end
          find("#admin_edit_btn_#{article.id}").click
          expect(current_path).to eq(edit_admins_article_path(article))
        end

        describe 'メンバー名を正しく編集できる' do
          context "メンバーを一人選択" do
            xit 'メンバー名編の編集に成功する' do
              expect(page).to have_checked_field("#{@name}")
              expect(page).to_not have_checked_field("#{@other_name}")
              check ("#{@other_name}")
              uncheck ("#{@name}")
              expect(page).to_not have_checked_field("#{@name}")
              expect(page).to have_checked_field("#{@other_name}")
              click_button '更新する'
              expect(page).to have_content('記事内容を更新しました。')
              expect(current_path).to eq(admins_articles_path)
              expect{
                article.reload
              }.to change{article.members}.from(article.members).to(other_article.members)
            end
          end

          context 'メンバーを複数選択' do
            xit 'メンバー名の編集に成功する' do
              expect(page).to have_checked_field("#{@name}")
              expect(page).to_not have_checked_field("#{@other_name}")
              check ("#{@other_name}")
              expect(page).to have_checked_field("#{@other_name}")
              click_button '更新する'
              expect(page).to have_content('記事内容を更新しました。')
              expect(current_path).to eq(admins_articles_path)
              expect(page).to have_content("#{@name}さん#{@other_name}さん")
            end
          end
        end
        
        xit 'ブランド名を正しく編集できる' do
          expect(page).to have_content('<brand>')
          fill_in 'article[brand]',	with: 'change_brand' 
          expect{
            click_button '更新する'
            sleep 0.5
          }.to change {article.reload.brand}.from(article.brand).to('change_brand')
          expect(page).to have_content('記事内容を更新しました。')
          expect(current_path).to eq(admins_articles_path)
        end
        
        xit 'アイテム名を正しく編集できる' do
          expect(page).to have_content('<item>')
          fill_in 'article[item]',	with: 'change_item' 
          expect{
            click_button '更新する'
            sleep 0.5
          }.to change {article.reload.item}.from(article.item).to('change_item')
          expect(page).to have_content('記事内容を更新しました。')
          expect(current_path).to  eq(admins_articles_path)
        end

        describe 'tweet_urlは一意でなければならない' do
          context 'tweet_urlが一意になっている' do
            xit 'tweet_urlの更新に成功する' do
            expect(page).to have_content('<Twitterへのurl>')
            expect(article.tweet_url).to eq("https://twitter.com/2jkhs6/status/1424628117360943107")
            fill_in 'article[tweet_url]',	with: "https://72"
            expect { 
              click_button '更新する'
              sleep 0.5
            }.to change { article.reload.tweet_url }.from("https://twitter.com/2jkhs6/status/1424628117360943107").to("https://72")
            expect(page).to have_content('記事内容を更新しました。')
            expect(current_path).to eq(admins_articles_path)
            end
          end

          context 'tweet_urlが一意になっていない' do
            let!(:article_tweet_url) { create(:article, :with_tweet_url_2) }
            xit 'tweet_urlの更新に失敗する' do
              expect(page).to have_content('<Twitterへのurl>')
              expect(article.tweet_url).to eq("https://twitter.com/2jkhs6/status/1424628117360943107")
              fill_in 'article[tweet_url]',	with: article_tweet_url.tweet_url
              expect { 
                click_button '更新する'
                sleep 0.5
              }.not_to change { article.reload.tweet_url }
              expect(page).to have_content('記事内容を更新できませんでした。')
              expect(current_path).to eq(admins_article_path(article))
            end
          end
        end
#ActiveStorage部分test作成
        describe '画像の編集' do
          xit '画像を削除することができる' do

          end

          xit '画像を選択することができる' do
          
          end
        end
      end

      describe '記事を削除できる' do
        xit '選択した記事の削除に成功する' do
          find("#admin_edit_btn_#{article.id}").click
          expect(current_path).to eq(edit_admins_article_path(article))
          expect{ 
          click_on '削除'
          sleep 0.5
            }.to change { Article.count }.by(-1)
        end
      end
    end
  end
end
