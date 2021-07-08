class Article < ApplicationRecord
  validates :url, uniqueness: true

  after_save :callback
  after_save :callback_HM, if: :hokuto?
  after_save :callback_TK, if: :taiga?
  after_save :callback_JT, if: :juri?
  after_save :callback_J, if: :jesse?
  after_save :callback_SM, if: :shintaro?
  after_save :callback_YK, if: :yugo?

  require 'Twitter'

  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end

  def get_url
    client.search("#oneST_衣装 OR #Taiga_Six衣装 OR #Jesse_Six衣装 OR #Hokuto_Six衣装 OR #Yugo_Six衣装 OR #Shintaro_Six衣装 OR #Juri_Six衣装", result_type: "recent", locale: "ja", exclude: "retweets").take(10).each do |article|
      tweet_body = article.text
      case 
      when tweet_body.include?("松村北斗")
        member = "松村北斗"
        url = article.url
      when tweet_body.include?("京本大我")
        member = "京本大我"
        url = article.url
      when tweet_body.include?("田中樹")
        member = "田中樹"
        url = article.url
      when tweet_body.include?("ジェシー")
        member = "ジェシー"
        url = article.url
      when tweet_body.include?("森本慎太郎")
        member = "森本慎太郎"
        url = article.url
      else
        member = "高地優吾"
        url = article.url
      end
      @article = Article.new(member: member, url: article.url)
      @article.save
    end
  end

  def hokuto?
    @article = Article.order(created::desc).limit(1) #ここの部分いらない?
    @article.name = "松村北斗"
  end

  def taiga?
    @article = Article.order(created::desc).limit(1)
    @article.name = "京本大我"
  end

  def juri?
    @article = Article.order(created::desc).limit(1)
    @article.name = "田中樹"
  end

  def jesse?
    @article = Article.order(created::desc).limit(1)
    @article.name = "ジェシー"
  end

  def shintaro?
    @article = Article.order(created::desc).limit(1)
    @article.name = "森本慎太郎"
  end

  def yugo?
    @article = Article.order(created::desc).limit(1)
    @article.name = "高地優吾"
  end
end
