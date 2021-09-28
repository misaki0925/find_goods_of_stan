require 'rails_helper'

RSpec.describe Article, type: :model do

#--- Twitter API使用したケース
  describe "Twitter API" do
    xit 'st_tweets_2メソッドでTwitter::searchオブジェクトを返すこと' do
      twitter_client_mock = double('Twitter client')
      expect(twitter_client_mock).to receive(:search).with("#Juri_Six衣装", result_type: "recent", locale: "ja", exclude: "retweets", tweet_mode: "extended").and_return("#<Twitter::SearchResults:0x00007ffc4ba49fa8>")

      article = Article.new
      expect(article).to receive(:twitter_client).and_return(twitter_client_mock)
      expect(article.st_tweets_2).to eq ("#<Twitter::SearchResults:0x00007ffc4ba49fa8>")
    end

    id = "1193544870444429313"
    xit 'twitter_searchメソッドでTwitter::searchオブジェクトを返すこと' do
      twitter_client_mock = double('Twitter client')
      expect(twitter_client_mock).to receive(:user_timeline).with(user_id: id, count: 1, exclude_replies: false, include_rts: false, contributor_details: false, result_type: "recent", locale: "ja", tweet_mode: "extended").and_return("#<Twitter::Tweet id=1436988816967933955>")

      article = Article.new
      expect(article).to receive(:twitter_client).and_return(twitter_client_mock)
      expect(article.twitter_search(id)).to eq ("#<Twitter::Tweet id=1436988816967933955>")
    end
  end
#--- Twitter API使用したケース
describe "その後のやり方" do
  let!(:tweet_content){"2021/6/6 ジャにのチャンネル
    Hey! Say! JUMP 山田涼介 私物 リング
    ブランド : BEAUTY & YOUTH
    カラー : シルバー(その他3)
    価格 : 7,150円
    T-shirt https://store.united-arrows.co.jp/shop/by/goods.html?did=52843833&utm_source=google&utm_medium=cpc&utm_campaign=ssc&utm_term=s00021&gclid=CjwKCAjwpMOIBhBAEiwAy5M6YIxOlkLhGcXJcu_s8gsJQcLobK5QewpGvJguVTHhG1MUd6ZPEujYwhoC2NEQAvD_BwE
    Selfie https://youtu.be/waDkGe0H9L4"}
    it 'テスト' do
      expect(article.price).to eq('¥7,150-')
      expect(article.brand).to eq('BEAUTY & YOUTH')
      expect(article.item).to eq('リング')
    end
  
end










# describe "データ編集" do
# let!(:tweet){"SixTONES
#   YouTube - ASMR!?音を立てずに食リポできるか選手権 他
  
#   松村北斗さん着用
  
#   【クレヨンしんちゃん】
#   Mクルーソックスひろしの靴下
#   white
#   ¥638- tax in
  
#   ※HP画像使わせて頂きました
  
#   #Hokuto_Six衣装"}
#   let!(:article) { create(:article, :with_member) }
#   let!(:members) {create(:members)}

#   it '正規表現でデータを分解し、memberを特定する' do
# byebug
#   article.set_st(tweet)

# end
# end

# it 'LINE API' do
#   # トップページとenumで公開と非公開記事を作成する
# end

end

