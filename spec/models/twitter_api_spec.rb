require 'rails_helper'

RSpec.describe Article, type: :model do

#--- Twitter API用モック
  describe "Twitter API" do
    id = "1193544870444429313"
    it 'twitter_searchメソッドでTwitter::searchオブジェクトを返すこと' do
      twitter_client_mock = double('Twitter client')
      expect(twitter_client_mock).to receive(:user_timeline).with(user_id: id, count: 1, exclude_replies: false, include_rts: false, contributor_details: false, result_type: "recent", locale: "ja", tweet_mode: "extended").and_return("#<Twitter::Tweet id=1436988816967933955>")
      article = Article.new
      expect(article).to receive(:twitter_client).and_return(twitter_client_mock)
      expect(article.search(id)).to eq ("#<Twitter::Tweet id=1436988816967933955>")
    end
  end
#--- twitter API で取得したツイートの内容を分解する
  describe "正規表現を使用したメソッド" do
    describe "GoodsFindというアカウント" do
      let!(:tweet){"SixTONES
        2021/05/16インスタライブ
        
        森本慎太郎さん着用
        
        【RESERVOIR Official Store】
        NEW LOGO TEE / Designed by GUCCIMAZE
        ¥4,000- tax in
        
        ※HP画像使わせて頂きました
        #findgoodsofstan #森本慎太郎"}
        it 'ツイートの分解に成功する' do
            tweet_content = tweet.gsub(/[\r\n]/,"")
            price = tweet_content.scan(/¥.+?-/).join(',')
            brand = tweet_content.scan(/(?<=\【).+?(?=\】)/).join(',')
            item = tweet_content.scan(/(?<=\】).+?(?=\¥)/).join(',')
            expect(price).to eq('¥4,000-')
            expect(brand).to eq('RESERVOIR Official Store')
            expect(item).to eq('        NEW LOGO TEE / Designed by GUCCIMAZE        ')
        end
    end

    describe "2jkhs6というアカウント" do
      let!(:tweet){"SixTONES
        「JESSEのズドン！BLOG」2021/08/25
        
        【LOUIS VUITTON】
        サングラス 1.1 エビデンス
        blank mat
        ¥83,600- tax in
        
        ※HP画像使わせて頂きました
        
        #Jesse_Six衣装"}
      it 'ツイートの分解に成功する' do
        tweet_content = tweet.gsub(/[\r\n]/,"")
        price = tweet_content.scan(/¥.+?-/).join(',')
        brand = tweet_content.scan(/(?<=\【).+?(?=\】)/).join(',')
        item = tweet_content.scan(/(?<=\】).+?(?=\¥)/).join(',')
        expect(price).to eq("¥83,600-")
        expect(brand).to eq("LOUIS VUITTON")
        expect(item).to eq("        サングラス 1.1 エビデンス        blank mat        ")
      end
    end

    describe "Johnnys_stylingというアカウント" do
      let!(:tweet){"SixTONES 松村北斗くん YouTube着用 私服
        onitsuka tiger ポロシャツ
        ¥25,000（参考価格）
        #SixTONES #松村北斗"}
        it 'ツイートの分解に成功する' do
          tweet_content = tweet
          ary = tweet_content.split("\n")
          price = "#{ary[-2]}-"
          item_brand = ary[-3]
          item = item_brand.split(" ").last
          brand = item_brand.split(item).join(',').gsub(/ /,"")
          expect(price).to eq("        ¥25,000（参考価格）-")
          expect(brand).to eq("onitsukatiger")
          expect(item).to eq("ポロシャツ")
        end
    end

    describe "jasmine_jumpというアカウント" do
      let!(:tweet){"2020/6/19 YouTubeにて着用
        SixTONES 田中樹
        ブランド : ZARA
        カラー : ホワイト
        (BUYMA)価格 : 7,999円
        T-shirt https://buyma.com/item/51042610/?af=4018
        Selfiehttps://youtu.be/pJB8LvYYGN0"}
        it 'ツイートの分解に成功する' do
          tweet_content = tweet
          tweet = "#{tweet_content.gsub(/[\r\n]/,"   ")}   "
          price = "¥#{tweet.scan(/(?<=\価格 : ).+?(?=\円)/).join(',')}-"
          brand = tweet.scan(/(?<=\ブランド : ).+?(?=\   )/).join(',')
          item = tweet.scan(/(?<=\私. ).+?(?=\   )/).join(',')
          expect(price).to eq("¥7,999-")
          expect(brand).to eq("ZARA")
          expect(item).to eq("")
        end
    end
  end
end
