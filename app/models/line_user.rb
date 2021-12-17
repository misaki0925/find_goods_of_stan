class LineUser < ApplicationRecord
  validates :line_user_id, uniqueness: true, presence: true
  enum yugo:{ on: 0, off: 1 }, _prefix: true
  enum taiga:{ on: 0, off: 1 }, _prefix: true
  enum juri:{ on: 0, off: 1 }, _prefix: true
  enum hokuto:{ on: 0, off: 1 }, _prefix: true
  enum jess:{ on: 0, off: 1 }, _prefix: true
  enum shintarou:{ on: 0, off: 1 }, _prefix: true

  #LINE Messaging API認証
  def self.client
      @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  #初めてリッチメニューをタッチした時か、メッセージが届いた時に、line_user_idが存在しているか判断し、リッチメニューを登録済み用に変更する
  def self.set_user_richmenue(user_id)
    if LineUser.find_by(line_user_id: user_id)
      @lineuser = LineUser.find_by(line_user_id: user_id)
    else
      @lineuser = LineUser.new(line_user_id: user_id)
      @lineuser.save!
    end
    client.link_user_rich_menu("#{@lineuser.line_user_id}", Settings.richmenu_id)
  end

  #ユーザーからメッセージが届いた際の対応
  def self.return_message(user_id)
    set_user_richmenue(user_id)
    message = 
        {
        "type": "flex",
        "altText": "メッセージありがとうございます。",
        "contents": {
          "type": "bubble",
          "body": {
            "type": "box",
            "layout": "vertical",
            "spacing": "sm",
            "contents": [
              {
                "type": "text",
                "text": "メッセージありがとうございます。",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "申し訳ございませんがこちらでは、",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "メッセージを受け付けておりません。",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "何かございましたら、以下のフォー",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "ムからお送りください。",
                "size": "md",
                "flex": 12
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
                  "label": "FindGoodsofStanサイトへ",
                  "uri": "https://www.findgoodsofstan.jp/reports/new"
                },
                "color": "#FCE3E7",
                "height": "md"
              }
            ]
          }
        }
      }
    client.push_message("#{@lineuser.line_user_id}", message)
  end

  #初めてリッチメニューをタッチした際の対応
  def self.start(user_id)
    set_user_richmenue(user_id)
    message = 
        {
        "type": "flex",
        "altText": "登録ありがとうございます。",
        "contents": {
          "type": "bubble",
          "body": {
            "type": "box",
            "layout": "vertical",
            "spacing": "sm",
            "contents": [
              {
                "type": "text",
                "text": "登録ありがとうございます!",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "SixTONESの私物がTwitterで特定さ",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "れた際にお知らせをお送りします。",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "また、通知を受け取るメンバーの",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "選択が可能です。",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "メニューからご確認ください。",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "サイトでは私物一覧を確認できます:)",
                "size": "md",
                "flex": 12
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
                  "label": "FindGoodsofStanサイトへ",
                  "uri": "https://www.findgoodsofstan.jp/"
                },
                "color": "#FCE3E7",
                "height": "md"
              }
            ]
          }
        }
      }
    client.push_message("#{@lineuser.line_user_id}", message)
  end

  #最新の情報を提供する(メンバー選択部分)
  def self.recent_item(user_id)
    message = 
      {
      "type": "flex",
      "altText": "最新の情報",
      "contents": {
        "type": "bubble",
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
              "text": "最新の情報"
            },
            {
              "type": "text",
              "text": "メンバーを選択してください。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
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
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "高地優吾さん",
                "displayText": "高地優吾さん",
                "data": "yugo_recent"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "京本大我さん",
                "displayText": "京本大我さん",
                "data": "taiga_recent"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "田中樹さん",
                "displayText": "田中樹さん",
                "data": "juri_recent"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "松村北斗さん",
                "displayText": "松村北斗さん",
                "data": "hokuto_recent"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "ジェシーさん",
                "displayText": "ジェシーさん",
                "data": "jess_recent"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "森本慎太郎さん",
                "displayText": "森本慎太郎さん",
                "data": "shintarou_recent"
              }
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end

  #最新の情報を提供する(情報送信部分)
  def self.send_recent_item(data, user_id)
    #dateの中を判断し、指定されたメンバーの最新情報を取得する
    if data.include?('yugo')
      member = Member.find(1)
      article = member.articles.order(created_at: :asc).last
    elsif data.include?('taiga')
      member = Member.find(2)
      article = member.articles.order(created_at: :asc).last
    elsif data.include?('juri')
      member = Member.find(3)
      article = member.articles.order(created_at: :asc).last
    elsif data.include?('hokuto')
      member = Member.find(4)
      article = member.articles.order(created_at: :asc).last
    elsif data.include?('jess')
      member = Member.find(5)
      article = member.articles.order(created_at: :asc).last
    elsif data.include?('shintarou')
      member = Member.find(6)
      article = member.articles.order(created_at: :asc).last
    end

    word = "#{article.brand}　#{article.price}　#{article.item}"
    enc = URI.encode_www_form_component(word)
    url = "https://www.google.co.jp/search?q="
    search_url = url+enc

    article.brand.present? ? brand = article.brand : brand = ""
    article.price.present? ? price = article.price : price = "  "

    message = 
      {
      "type": "flex",
      "altText": "#{member.name}さんの最新情報",
      "contents": {
        "type": "bubble",
        "hero": {
          "type": "image",
          "url": "#{article.line_image_url ||= Settings.defualts_url}",
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
              "text": "#{member.name}さん着用"
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
                "uri": "#{article.tweet_url}"
              }
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end

  #メンバー別に通知を設定(メンバー指定部分)
  def self.set_member(user_id)
    message = 
      {
      "type": "flex",
      "altText": "メンバー設定",
      "contents": {
        "type": "bubble",
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
              "text": "メンバー設定"
            },
            {
              "type": "text",
              "text": "通知を受け取るメンバーを設定します。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
            },
            {
              "type": "text",
              "text": "設定したいメンバーを選択してください。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
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
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "高地優吾さん",
                "displayText": "高地優吾さんの情報について設定する",
                "data": "yugo_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "京本大我さん",
                "displayText": "京本大我さんの情報について設定する",
                "data": "taiga_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "田中樹さん",
                "displayText": "田中樹さんの情報について設定する",
                "data": "juri_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "松村北斗さん",
                "displayText": "松村北斗さんの情報について設定する",
                "data": "hokuto_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "ジェシーさん",
                "displayText": "ジェシーさんの情報について設定する",
                "data": "jess_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "森本慎太郎さん",
                "displayText": "森本慎太郎さんの情報について設定する",
                "data": "shintarou_info"
              }
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end

  #メンバー別に通知を設定(通知on,off選択部分)
  def self.settei_member(data, user_id)
    data_member_check(data)
    #dateのメンバー名の部分のみ抜き出し
    data.slice!(-5,5)
    message = 
      {
      "type": "flex",
      "altText": "メンバー別通知設定",
      "contents": {
        "type": "bubble",
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
              "text": "通知設定"
            },
            {
              "type": "text",
              "text": "#{@name}さんの通知について設定します。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
            },
            {
              "type": "text",
              "text": "複数のメンバーの通知を受け取る場合、",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
            },
            {
              "type": "text",
              "text": "それぞれ設定してください。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
            },
            {
              "type": "text",
              "text": "いつでも変更可能です。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
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
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "通知を受け取る",
                "displayText": "#{@name}さんの情報を受け取る",
                "data": "on_#{data}"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "通知を受け取らない",
                "displayText": "#{@name}さんの情報を受け取らない",
                "data": "off_#{data}"
              }
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end

  #メンバー別に通知を設定(選択したメンバーの通知をonにし、結果を送信)
  def self.on_info(data, user_id)
    data_member_check(data)
    @user = LineUser.find_by(line_user_id: user_id)
    if data.include?('yugo')
      @user.yugo_on!
    elsif data.include?('taiga')
      @user.taiga_on!
    elsif data.include?('juri')
      @user.juri_on!
    elsif data.include?('hokuto')
      @user.hokuto_on!
    elsif data.include?('jess')
      @user.jess_on!
    elsif data.include?('shintarou')
      @user.shintarou_on!
    end
    message = 
      {
      "type": "flex",
      "altText": "メンバー別通知設定",
      "contents": {
        "type": "bubble",
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
              "text": "通知設定完了"
            },
            {
              "type": "text",
              "text": "#{@name}さんの情報について",
              "size": "md",
              "flex": 12
            },
            {
              "type": "text",
              "text": "通知をお送りします。",
              "size": "md",
              "flex": 12
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end

  #メンバー別に通知を設定(選択したメンバーの通知をoffにし、結果を送信)
  def self.off_info(data, user_id)
    data_member_check(data)
    @user = LineUser.find_by(line_user_id: user_id)
    if data.include?('yugo')
      @user.yugo_off!
    end
    if data.include?('taiga')
      @user.taiga_off!
    end
    if data.include?('juri')
      @user.juri_off!
    end
    if data.include?('hokuto')
      @user.hokuto_off!
    end
    if data.include?('jess')
      @user.jess_off!
    end
    if data.include?('shintarou')
      @user.shintarou_off!
    end
    message = 
      {
      "type": "flex",
      "altText": "メンバー別通知設定",
      "contents": {
        "type": "bubble",
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
              "text": "通知設定完了"
            },
            {
              "type": "text",
              "text": "#{@name}さんの情報について",
              "size": "md",
              "flex": 12
            },
            {
              "type": "text",
              "text": "通知をお送りしません。",
              "size": "md",
              "flex": 12
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end

  #dataでユーザーを判定する
  def self.data_member_check(data)
    @name = '高地優吾' if data.include?('yugo')
    @name = '京本大我' if data.include?('taiga')
    @name = '田中樹' if data.include?('juri')
    @name = '松村北斗' if data.include?('hokuto')
    @name = 'ジェシー' if data.include?('jess')
    @name = '森本慎太郎' if data.include?('shintarou')
  end

  #メンバー設定を一覧で表示する
  def self.all_member_setting(user_id)
    user = LineUser.find_by(line_user_id: user_id)
    user.yugo == "off" ? yugo_status = "OFF" : yugo_status = "ON"
    user.taiga == "off" ? taiga_status = "OFF" : taiga_status = "ON"
    user.juri == "off" ? juri_status = "OFF" : juri_status = "ON"
    user.hokuto == "off" ? hokuto_status = "OFF" : hokuto_status = "ON"
    user.jess == "off" ? jess_status = "OFF" : jess_status = "ON"
    user.shintarou == "off" ? shintarou_status = "OFF" : shintarou_status = "ON"
    message = 
      {
      "type": "flex",
      "altText": "メンバー設定一覧",
      "contents": {
        "type": "bubble",
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
              "text": "メンバー設定一覧"
            },
            {
              "type": "text",
              "text": "現在のメンバー別通知設定一覧です。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
            },
            {
              "type": "text",
              "text": "メンバー名を押すと変更可能です。",
              "color": "#aaaaaa",
              "size": "sm",
              "flex": 12
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
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "高地優吾さん　  通知#{yugo_status}",
                "displayText": "高地優吾さんの情報について設定する",
                "data": "yugo_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "京本大我さん　  通知#{taiga_status}",
                "displayText": "京本大我さんの情報について設定する",
                "data": "taiga_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "田中樹さん　　  通知#{juri_status}",
                "displayText": "田中樹さんの情報について設定する",
                "data": "juri_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "松村北斗さん　  通知#{hokuto_status}",
                "displayText": "松村北斗さんの情報について設定する",
                "data": "hokuto_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "ジェシーさん　  通知#{jess_status}",
                "displayText": "ジェシーさんの情報について設定する",
                "data": "jess_info"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "森本慎太郎さん  通知#{shintarou_status}",
                "displayText": "森本慎太郎さんの情報について設定する",
                "data": "shintarou_info"
              }
            }
          ]
        }
      }
    }
    client.push_message(user_id, message)
  end
end
