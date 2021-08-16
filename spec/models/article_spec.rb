require 'rails_helper'

RSpec.describe Article, type: :model do
  describe 'Article.rbが正しく作動するか' do
  describe 'Twitter API部分' do
    describe '検索実行後、該当するツイートを返すこと' do
      it 'ネストなし' do
      goods_mock = double('goods')
      allow(goods_mock).to receive(:text).and_return('京本大我腕やばい男')
      twitter_client_mock = double('Twitter client')
      allow(twitter_client_mock).to receive(:search).and_return([goods_mock
      allow(Article).to receive(:twitter_client).and_return(twitter_client_moc
      expect(Article.search_taiga).to eq '京本大我腕やばい男'
    end
  end
    end
  end
  end
  describe 'ActiveStorage部分' do
  end
  describe 'LINE通知部分' do
  end

    
  end
  

    # 検索実行

    # 本文の検索
    goods_mock_s = double('goods_tweet_s')
    allow(goods_mock).to receive(:).and_return('京本大我腕やばい男')


    goods_mock = double('goods_tweet')
    allow(goods_mock).to receive(:search).and_return([goods_mock_s])


      twitter_client_mock = double('Twitter client')
      allow(twitter_client_mock).to receive(:twitter_client).and_return([goods_mock])

  end


  it '「天気」を含むツイートを返すこと' do
    weather_bot = Article
    allow(weather_bot).to receive_message_chain('twitter_client.search.take(1).each').and_return(')
  
    expect(weather_bot.search_first_weather_tweet).to eq '西脇市の天気は曇りです'
  end





  # describe "モデル" do
  #   xit '「ツイートを返すこと」ネスト' do
      
  #   end
    
  #   it 'ネスト' do
  #     # article_bot = Article.new
  #     allow(Article).to receive_message_chain('twitter_client.search.first.text').and_return('京本大我腕やばい男')
  #     expect(Article.search_taiga).to  eq '京本大我腕やばい男'
  #   end

  #   it 'ネストなし' do
  #     goods_mock = double('goods')
  #     allow(goods_mock).to receive(:text).and_return('京本大我腕やばい男')

  #     twitter_client_mock = double('Twitter client')
  #     allow(twitter_client_mock).to receive(:search).and_return([goods_mock])

  #     allow(Article).to receive(:twitter_client).and_return(twitter_client_mock)

  #     expect(Article.search_taiga).to eq '京本大我腕やばい男'
  #   end
  # end

  
end
