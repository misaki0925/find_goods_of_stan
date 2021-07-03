class Article < ApplicationRecord
  belongs_to :member
  validates :url, uniqueness: true

  require 'Twitter'

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end

  def get_url
    # 指定したタグのツイート取得
    tag = "#SixTONES_私服"
    result_tweets = client.search(tag , lang:ja, result_type: ‘recent’, count: 3)
    # 取得したツイートのurl作成
    result_tweets.each do |result_tweet|
      result_screen_name = result_tweet.user.name
      result_id = result_tweet.id
      url_1 = "https://twitter.com/"
      url_2 = "/status/"
      url = url_1+result_tweet_screen_name+url_2+result_tweet_id
      url.save
    end
    
    
  end
  
end
