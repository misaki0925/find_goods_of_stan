class Article < ApplicationRecord
  has_many :article_members, dependent: :destroy
  has_many :members, through: :article_members
  accepts_nested_attributes_for :article_members, allow_destroy: true
  has_many_attached :images

  validates :tweet_url, uniqueness: true

  require 'Twitter'
  require 'line/bot'
  require 'open-uri'

  #Twitter API
  def self.get_tweets
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_SECRET"]
    end

    client.search("#oneST_衣装 OR #Taiga_Six衣装 OR #Jesse_Six衣装 OR #Hokuto_Six衣装 OR #Yugo_Six衣装 OR #Shintaro_Six衣装 OR #Juri_Six衣装", result_type: "recent", locale: "ja", exclude: "retweets", tweet_mode: "extended").take(1).each do |tweet|
    
      tweet_content = tweet.text
      price = tweet_content.slice(/¥.*-/)
      brand = tweet_content.slice(/(?<=\【).*?(?=\】)/)

      # インスタンス作成
     @article = Article.new(price: price, brand: brand, tweet_url: tweet.url)

  
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

      names = []
      @article.members.each do |member|
        names.push(member.name)
      end
      @names = names.join("さん")
  
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
      @article.send_line(@article.member_ids, @names, @article.tweet_url, @imgae_url_for_line_small)
      end
    end
  end
     
  # LINE APIを使用して該当するメンバーのLINEbotに送信する
  def send_line(member_ids, name, tweet_url, tweet_image_url)
    unless member_ids.empty?
      ids = member_ids.map(&:to_s)
      ids.each do |id|
        @line_names = ["ALL"]
        @line_names << "YK" if id.include?("1")
        @line_names << "TK" if id.include?("2")
        @line_names << "JT" if id.include?("3")
        @line_names << "HM" if id.include?("4")
        @line_names << "J" if id.include?("5")
        @line_names << "SM" if id.include?("6")
      end
    end

    @line_names.each do |line_name|
      client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET_#{line_name}"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN_#{line_name}"]
    }

    message = {
      "type": "flex",
      "altText": "#{name}さんの私物が特定されました！(Twitter)",
      "contents": 
          {
            "type": "bubble",
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "image",
                  "url": "#{tweet_image_url}",
                  "size": "full",
                  "aspectMode": "cover",
                  "aspectRatio": "2:3",
                  "gravity": "top"
                },
                {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": "#{name}さん着用",
                          "size": "xl",
                          "color": "#ffffff",
                          "weight": "bold",
                          "align": "center"
                        }
                      ]
                    },
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "filler"
                        },
                        {
                          "type": "box",
                          "layout": "baseline",
                          "contents": [
                            {
                              "type": "filler"
                            },
                            {
                              "type": "text",
                              "text": "Twitterへ",
                              "color": "#ffffff",
                              "flex": 0,
                              "offsetTop": "-2px",
                              "action": {
                                "type": "uri",
                                "label": "action",
                                "uri": "#{tweet_url}"
                              }
                            },
                            {
                              "type": "filler"
                            }
                          ],
                          "spacing": "sm"
                        },
                        {
                          "type": "filler"
                        }
                      ],
                      "borderWidth": "1px",
                      "cornerRadius": "4px",
                      "spacing": "sm",
                      "borderColor": "#ffffff",
                      "margin": "xxl",
                      "height": "40px"
                    }
                  ],
                  "position": "absolute",
                  "offsetBottom": "0px",
                  "offsetStart": "0px",
                  "offsetEnd": "0px",
                  "paddingAll": "20px",
                  "paddingTop": "18px"
                }
              ],
              "paddingAll": "0px"
            }
          }
        }
    response = client.broadcast(message)
    p response
    end
  end
end
