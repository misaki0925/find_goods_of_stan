# モデル部分

require 'twitter'

class WeatherBot
  def tweet_forecast
    twitter_client.update '今日は晴れです'
  end

  def twitter_client
    Twitter::REST::Client.new
  end
end


# 普通のテスト部分

it 'エラーなく予報をツイートすること' do
  weather_bot = WeatherBot.new # (twitter_client部分)
  expect{ weather_bot.tweet_forecast (tweet_forecast部分) }.not_to raise_error
end

it 'ネストさせちゃう' do
  article_bot = article
  allow(article_bot).to receive_message_chain('search_client.search.take(1).each').and_return('京本大我さん')
  expect(article_bot.search_tweets).to eq '京本大我さん'

end


# モックを利用したテスト
# Twitterと連携するbubunnwoモックに置き換えをしてtwitterとの通信が発生しないようにする
it 'エラーなく予報をツイートすること' do
  1 # Twitter clientのモックを作る
  # 名前指定して偽のTwitter::REST::Clientを作製
  twitter_client_mock = double('Twitter clientここエラーの時に表示される')
  
  2-1# updateメソッドが呼びだせるようにする 
  # def twitter_client Twitter::REST::Client.new endがdef tweet_forecastないで呼び出されるから
  # allow(モックオブジェクト).to receive(メソッド名)
  allow(twitter_client_mock).to receive(:update)　こっちは実装を置き換えるのみ

  2-改良# updateメソッドが呼ばれることも合わせて検証する
  expect(twitter_client_mock).to receive(:update)　こっちは実装を置き換え、メソッドが呼び出されるか検証する


  3 weather_bot = WeatherBot.new
  # twitter_clientメソッドが呼ばれたら上で作ったモックを返すように実装を書き換える
  # allow(実装を置き換えたいオブジェクト).to receive(置き換えたいメソッド名).and_return(返却したい値やオブジェクト)
  allow(weather_bot).to receive(:twitter_client).and_return(twitter_client_mock)

  4 
  expect{ weather_bot.tweet_forecast }.not_to raise_error
end







# article.rb 部分--------------------------

 def twitter_client
  Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end
end


def search_st

  twitter_client.search("#oneST_衣装 OR #Taiga_Six衣装 OR #Jesse_Six衣装 OR #Hokuto_Six衣装 OR #Yugo_Six衣装 OR #Shintaro_Six衣装 OR #Juri_Six衣装", result_type: "recent", locale: "ja", exclude: "retweets", tweet_mode: "extended").take(1).each do |tweet|
  
  tweet_content = tweet.text.gsub(/[\r\n]/,"")
  price = tweet_content.slice(/¥.*-/)
  brand = tweet_content.slice(/(?<=\【).*?(?=\】)/)
  item = tweet_content.slice(/(?<=\】).*?(?=\¥)/)
  

  # インスタンス作成
 @article = Article.new(price: price, brand: brand, item: item, tweet_url: tweet.url)
  end



    # articleにmemberを紐づける
    member_ids = []
    member_ids << 1 if tweet_content.include?("優吾")
    member_ids << 2 if tweet_content.include?("京本大我")
    member_ids << 3 if tweet_content.include?("田中樹")
    member_ids << 4 if tweet_content.include?("松村北斗")
    member_ids << 5 if tweet_content.include?("ジェシー")
    member_ids << 6 if tweet_content.include?("森本慎太郎")
    article_members = Member.find(member_ids)
    @article.members << article_members



    # 画像
    medias = tweet.media
    image_urls = medias.map{ |h| h.media_url_https }
    # LINE送信用の画像url作成
    imgae_url_for_line = image_urls.first
    @imgae_url_for_line_small = "#{imgae_url_for_line}:small"
    # 画像をActiveStorageに保存
    image_urls.each_with_index do |image_url, i|
      image_url_small = "#{image_url}:small"
      io = open(image_url_small)
      @article.images.attach(io: io, filename: "#{@article.id}_#{i}")
    end



    if @article.save
    # send_lineで送信
    @article.send_line(@article.member_ids, @article.tweet_url, @imgae_url_for_line_small)
    end


  end
end
   






