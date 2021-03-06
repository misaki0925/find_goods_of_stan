class Article < ApplicationRecord
  has_many :article_members, dependent: :destroy
  has_many :members, through: :article_members
  accepts_nested_attributes_for :article_members, allow_destroy: true
  has_many_attached :images

  validates :tweet_url, uniqueness: true, presence: true

  enum status:{ published: 0, draft: 1 }

  # require 'Twitter'
  # require 'line/bot'
  require 'open-uri'

  #Twitterclient認証
  def twitter_client
    @twitter_client ||= Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_SECRET"]
    end
  end

  # 指定したidのアカウントのツイート検索
  def search(id)
    @tweets = twitter_client.user_timeline(user_id: id, count: 1, exclude_replies: false, include_rts: false, contributor_details: false, result_type: "recent", locale: "ja", tweet_mode: "extended")
  end

  # 検索したツイートが私物関連のものであるか判断
  def set_article(tag)
    @for_article_tweets = []
    @tweets.each do |tweet|
      @for_article_tweets << tweet if tag.any?{|t| tweet.text.include?(t)}
    end
  end

  # 関係するメンバーを判断
  def check_member(tweet_content)
    member_ids = []
      yugo = ["#高地優吾"]
      taiga = ["#京本大我"]
      juri = ["#田中樹"]
      hokuto = ["#松村北斗"]
      jess = ["#ジェシー"]
      shintaro = ["#森本慎太郎"]

      member_ids << 1 if yugo.any?{ |y| tweet_content.include?(y) }
      member_ids << 2 if taiga.any?{ |t| tweet_content.include?(t) }
      member_ids << 3 if juri.any?{ |j| tweet_content.include?(j) }
      member_ids << 4 if hokuto.any?{ |h| tweet_content.include?(h) }
      member_ids << 5 if jess.any?{ |j| tweet_content.include?(j) }
      member_ids << 6 if shintaro.any?{ |s| tweet_content.include?(s) }

      members << Member.find(member_ids)
  end

  # 関係するメンバーを判断(2jkhs6用)
  def check_member_2jkhs6(tweet_content)
    member_ids = []
      yugo = ["#Yugo_Six衣装"]
      taiga = ["#Taiga_Six衣装"]
      juri = ["#Juri_Six衣装"]
      hokuto = ["#Hokuto_Six衣装"]
      jess = ["#Jesse_Six衣装"]
      shintaro = ["#Shintaro_Six衣装"]

      member_ids << 1 if yugo.any?{ |y| tweet_content.include?(y) }
      member_ids << 2 if taiga.any?{ |t| tweet_content.include?(t) }
      member_ids << 3 if juri.any?{ |j| tweet_content.include?(j) }
      member_ids << 4 if hokuto.any?{ |h| tweet_content.include?(h) }
      member_ids << 5 if jess.any?{ |j| tweet_content.include?(j) }
      member_ids << 6 if shintaro.any?{ |s| tweet_content.include?(s) }
      article_members = Member.find(member_ids)
      members << article_members
  end

  # ツイートに含まれる画像を保存
  def set_images(medias)
    image_urls = medias.map{ |h| h.media_url_https }
    # LINE送信用の画像url作成
    imgae_url_for_line = image_urls.first
    self.line_image_url = "#{imgae_url_for_line}:small"
    # 画像をActiveStorageに保存
    image_urls.each_with_index do |image_url, i|
      image_url_small = "#{image_url}:small"
      io = open(image_url_small)
      self.images.attach(io: io, filename: "image_#{i}")
    end
  end

  # LINE APIで送信する
  def send_line(member_ids, tweet_url, tweet_image_url)
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }

    unless member_ids.empty?
      ids = member_ids.map(&:to_s)
    end
    
    #通知onにしているユーザーのline_user_idをにまとめる
    names = []
    user_ids = []

    if ids.include?("1")
      names << "高地優吾さん" 
      LineUser.yugo_on.each {|lineuser| user_ids << lineuser.line_user_id unless user_ids.include?(lineuser.line_user_id)}
    end
    if ids.include?("2")
      names << "京本大我さん" 
      LineUser.taiga_on.each {|lineuser| user_ids << lineuser.line_user_id unless user_ids.include?(lineuser.line_user_id)}
    end

    if ids.include?("3")
      names << "田中樹さん" 
      LineUser.juri_on.each {|lineuser| user_ids << lineuser.line_user_id unless user_ids.include?(lineuser.line_user_id)}
    end

    if ids.include?("4")
      names << "松村北斗さん"
      LineUser.hokuto_on.each {|lineuser| user_ids << lineuser.line_user_id unless user_ids.include?(lineuser.line_user_id)}
    end

    if ids.include?("5")
      names << "ジェシーさん"
      LineUser.jess_on.each {|lineuser| user_ids << lineuser.line_user_id unless user_ids.include?(lineuser.line_user_id)}
    end

    if ids.include?("6")
      names << "森本慎太郎さん"
      LineUser.shintarou_on.each {|lineuser| user_ids << lineuser.line_user_id unless user_ids.include?(lineuser.line_user_id)}
    end


    word = "#{self.brand}　#{self.price}　#{self.item}"
    enc = URI.encode_www_form_component(word)
    url = "https://www.google.co.jp/search?q="
    search_url = url+enc

    self.brand.present? ? brand = self.brand : brand = ""
    self.price.present? ? price = self.price : price = "  "

    message = 
      {
      "type": "flex",
      "altText": "#{names.join('と')}の私物が特定されました！(Twitter)",
      "contents": {
        "type": "bubble",
        "hero": {
          "type": "image",
          "url": tweet_image_url,
          "size": "full",
          "aspectRatio": "20:28",
          "aspectMode": "cover"
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "text",
              "wrap": true,
              "weight": "bold",
              "size": "xl",
              "text": "#{names.join('と')}着用"
            },
            {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{brand}",
                  "wrap": true,
                  "weight": "bold",
                  "size": "xl",
                  "flex": 0
                },
                {
                  "type": "text",
                  "text": "#{price}",
                  "wrap": true,
                  "weight": "bold",
                  "size": "sm",
                  "flex": 0
                }
              ]
            }
          ]
        },
        "footer": {
          "type": "box",
          "layout": "vertical",
          "spacing": "sm",
          "contents": [
            {
              "type": "button",
              "style": "secondary",
              "action": {
                "type": "uri",
                "label": "商品検索",
                "uri": "#{search_url}"
              },
              "color": "#FCE3E7",
              "height": "md"
            },
            {
              "type": "button",
              "action": {
                "type": "uri",
                "label": "To tweet",
                "uri": "#{tweet_url}"
              }
            }
          ]
        }
      }
    }
    client.multicast(user_ids, message)
  end

    #  GoodsFindというアカウントのツイート検索
    def make_goods_find_article
      search(Settings.goods_find)
      tag = ["#findgoodsofstan"]
      set_article(tag)
      @for_article_tweets.each do |tweet|
        tweet_content = tweet.text.gsub(/[\r\n]/,"")
        self.tweet_url = tweet.url
        self.price = tweet_content.scan(/¥.+?-/).join(',')
        self.brand = tweet_content.scan(/(?<=\【).+?(?=\】)/).join(',')
        self.item = tweet_content.scan(/(?<=\】).+?(?=\¥)/).join(',')
        check_member(tweet_content)
        set_images(tweet.media)
        if save
          send_line(member_ids, tweet_url, line_image_url)
        end
      end
    end

  #2jkhs6というアカウントのツイート検索
  def make_2jkhs6_article
    search(Settings.jkhs)
    tag = ["#oneST_衣装", "#Taiga_Six衣装", "#Jesse_Six衣装", "#Hokuto_Six衣装", "#Yugo_Six衣装", "#Shintaro_Six衣装", "#Juri_Six衣装"]
    set_article(tag)
    @for_article_tweets.each do |tweet|
      tweet_content = tweet.text.gsub(/[\r\n]/,"")
      self.tweet_url = tweet.url
      self.price = tweet_content.scan(/¥.+?-/).join(',')
      self.brand = tweet_content.scan(/(?<=\【).+?(?=\】)/).join(',')
      self.item = tweet_content.scan(/(?<=\】).+?(?=\¥)/).join(',')
      check_member_2jkhs6(tweet_content)
      set_images(tweet.media)
      if save
        send_line(member_ids, tweet_url, line_image_url)
      end
    end
  end

  # Johnnys_stylingというアカウントのツイート検索
  def make_johnnys_styling_article
    search(Settings.johnnys_styling)
    tag = ["#SixTONES", "#高地優吾", "#京本大我", "#田中樹", "#松村北斗", "#ジェシー","#森本慎太郎"]
    set_article(tag)
    @for_article_tweets.each do |tweet|
      tweet_content = tweet.text
      self.tweet_url = tweet.url
      ary = tweet_content.split("\n")
      self.price = "#{ary[-2]}-"
      item_brand = ary[-3]
      self.item = item_brand.split(" ").last
      self.brand = item_brand.split(self.item).join(',').gsub(/ /,"")
      check_member(tweet_content)
      set_images(tweet.media)
      if save
        send_line(member_ids, tweet_url, line_image_url)
      end
    end
  end
end
