class Article < ApplicationRecord
  has_many :article_members, dependent: :destroy
  has_many :members, through: :article_members
  accepts_nested_attributes_for :article_members, allow_destroy: true
  has_many_attached :images

  validates :tweet_url, uniqueness: true

  require 'Twitter'
  require 'line/bot'

  #Twitter API
  client = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV["CONSUMER_KEY"]
    config.consumer_secret     = ENV["CONSUMER_SECRET"]
    config.access_token        = ENV["ACCESS_TOKEN"]
    config.access_token_secret = ENV["ACCESS_SECRET"]
  end

  def get_url
    client.search("#oneST_衣装 OR #Taiga_Six衣装 OR #Jesse_Six衣装 OR #Hokuto_Six衣装 OR #Yugo_Six衣装 OR #Shintaro_Six衣装 OR #Juri_Six衣装", result_type: "recent", locale: "ja", exclude: "retweets", tweet_mode: "extended").take(10).each do |article|
      tweet = article.text
      tweet.include?("優吾") ? yugo_type = :yugo : yugo_type = :not_yugo
      tweet.include?("京本大我") ? taiga_type = :taiga : taiga_type = :not_taiga
      tweet.include?("田中樹") ? juri_type = :juri : juri_type = :not_juri
      tweet.include?("松村北斗") ? hokuto_type = :hokuto : hokuto_type = :not_hokuto
      tweet.include?("ジェシー") ? jesse_type = :jesse : jesse_type = :not_jesse
      tweet.include?("森本慎太郎") ? shintaro_type = :shintaro : shintaro_type = :not_shintaro
      @article = Article.new(yugo_type: yugo_type, taiga_type: taiga_type, juri_type: juri_type, hokuto_type: hokuto_type, jesse_type: jesse_type, shintaro_type: shintaro_type, url: article.url)
      @article.save
      @article.send_line_all
      @article.send_line_member
    end
  end
#LINE API

#全体用LINEAPI
  def send_line_all
#client設定
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

#ユーザーへメッセージを送信する
    message = {
      type: 'text',
      text: @article.url
        } 
    response = client.push_message(ENV["LINE_USER_ID"], message)
    p response
  end

#個別LINEAPI
  def send_line_member
    case
    when @article.yugo?
      channel_secret = ENV["LINE_CHANNEL_SECRET_YK"]
      channel_access_token = ENV["LINE_CHANNEL_TOKEN_YK"]
      userId = ENV["LINE_USER_ID_YK"]
    when @article.taiga?
      channel_secret = ENV["LINE_CHANNEL_SECRET_TK"]
      channel_access_token = ENV["LINE_CHANNEL_TOKEN_TK"]
      userId = ENV["LINE_USER_ID_KT"]
    when @article.juri?
      channel_secret = ENV["LINE_CHANNEL_SECRET_JT"]
      channel_access_token = ENV["LINE_CHANNEL_TOKEN_JT"]
      userId = ENV["LINE_USER_ID_JT"]
    when @article.hokuto?
      channel_secret = ENV["LINE_CHANNEL_SECRET_HM"]
      channel_access_token = ENV["LINE_CHANNEL_TOKEN_HM"]
      userId = ENV["LINE_USER_ID_HM"]
    when @article.jesse?
      channel_secret = ENV["LINE_CHANNEL_SECRET_J"]
      channel_access_token = ENV["LINE_CHANNEL_TOKEN_J"]
      userId = ENV["LINE_USER_ID_J"]
    when @article.shintaro?
      channel_secret = ENV["LINE_CHANNEL_SECRET_SM"]
      channel_access_token = ENV["LINE_CHANNEL_TOKEN_SM"]
      userId = ENV["LINE_USER_ID_SM"]
    else
      #何もしない
    end

    client = Line::Bot::Client.new { |config|
      config.channel_secret = channel_secret
      config.channel_token = channel_access_token
    }

  #ユーザーへメッセージを送信する
    message = {
      type: 'text',
      text: @article.url
        } 
    response = client.push_message(userId, message)
    p response
  end
end



