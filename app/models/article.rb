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

  # Twitterclient
  def twitter_client
    Twitter::REST::Client.new do |config|
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
      yugo = ["優吾","優吾のあしあと"]
      taiga = ["京本大我","きょも","きょもきょも美術館"]
      juri = ["田中樹","リリックノート"]
      hokuto = ["松村北斗","北斗学園"]
      jess = ["ジェシー","JESSEのズドン！BLOG"]
      shintaro = ["森本慎太郎","もりもとーく"]

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
    # imgae_url_for_line = image_urls.last
    @imgae_url_for_line_small = "#{imgae_url_for_line}:small"
    # 画像をActiveStorageに保存
    image_urls.each_with_index do |image_url, i|
      image_url_small = "#{image_url}:small"
      io = open(image_url_small)
      self.images.attach(io: io, filename: "image_#{i}")
    end
  end

# LINE APIで送信する
  def send_line(member_ids, tweet_url, tweet_image_url)
    unless member_ids.empty?
      ids = member_ids.map(&:to_s)
      @line_names = ["ALL"]
      ids.each do |id|
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

    name = "高地優吾さん" if ids.include?("1")
    name = "京本大我さん" if ids.include?("2")
    name = "田中樹さん" if ids.include?("3")
    name = "松村北斗さん" if ids.include?("4")
    name = "ジェシーさん" if ids.include?("5")
    name = "森本慎太郎さん" if ids.include?("6")

    word = "#{self.brand}　#{self.price}　#{self.item}"
    enc = URI.encode_www_form_component(word)
    url = "https://www.google.co.jp/search?q="
    search_url = url+enc
    
    message = 
      {
      "type": "flex",
      "altText": "#{name}の私物が特定されました！(Twitter)",
      "contents": {
        "type": "bubble",
        "hero": {
          "type": "image",
          "size": "full",
          "aspectRatio": "20:28",
          "aspectMode": "cover",
          "url": tweet_image_url
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
              "text": "#{name}着用"
            },
            {
              "type": "box",
              "layout": "baseline",
              "contents": [
                {
                  "type": "text",
                  "text": "#{self.brand}",
                  "wrap": true,
                  "weight": "bold",
                  "size": "xl",
                  "flex": 0
                },
                {
                  "type": "text",
                  "text": "#{self.price}",
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
                "uri": "#{search_url}",
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
    response = client.broadcast(message)
    p response
    end
  end


    #  GoodsFindというアカウントのツイート検索-------
    def make_GoodsFind_article
      search("1407908082575765506")
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
          send_line(member_ids, tweet_url, @imgae_url_for_line_small)
        end
      end
    end

  # 2jkhs6というアカウントのツイート検索------
  def make_2jkhs6_article
    search("1193544870444429313")
    tag = ["#oneST_衣装", "#Taiga_Six衣装", "#Jesse_Six衣装", "#Hokuto_Six衣装", "#Yugo_Six衣装", "#Shintaro_Six衣装", "#Juri_Six衣装"]
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
        send_line(member_ids, tweet_url, @imgae_url_for_line_small)
      end
    end
  end

  # Johnnys_stylingというアカウントのツイート検索-----------
  def make_Johnnys_styling_article
    search("934773122653229056")
    tag = ["#SixTONES", "#高地優吾", "#京本大我", "#田中樹", "#松村北斗", "#ジェシー","#森本慎太郎"]
    set_article(tag)
    @for_article_tweets.each do |t|
      tweet_content = t.text
      self.tweet_url = t.url
      ary = tweet_content.split("\n")
      self.price = "#{ary[-2]}-"
      item_brand = ary[-3]
      self.item = item_brand.split(" ").last
      self.brand = item_brand.split(self.item).join(',').gsub(/ /,"")
      check_member(tweet_content)
      set_images(t.media)
      if save
        send_line(member_ids, tweet_url, @imgae_url_for_line_small)
      end
    end
  end

# jasmine_jumpというアカウントのツイート検索---------------
  def make_jasmine_jump_article
    search("842986230442676224")
    tag = ["高地優吾", "京本大我", "田中樹", "松村北斗", "ジェシー","森本慎太郎"]
    set_article(tag)
    @for_article_tweets.each do |t|
      tweet_content = t.text
      self.tweet_url = t.url
      tweet = "#{tweet_content.gsub(/[\r\n]/,"   ")}   "
      self.price = "¥#{tweet.scan(/(?<=\価格 : ).+?(?=\円)/).join(',')}-"
      self.brand = tweet.scan(/(?<=\ブランド : ).+?(?=\   )/).join(',')
      self.item = tweet.scan(/(?<=\私. ).+?(?=\   )/).join(',')
      check_member(tweet_content)
      set_images(t.media)
      if save
        send_line(member_ids, tweet_url, @imgae_url_for_line_small)
      end
    end
  end
end

