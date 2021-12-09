class LineUsersController < ApplicationController
  skip_before_action :require_login
  skip_before_action :verify_authenticity_token
  require 'line/bot'

  def client
    client = Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET_ALL"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN_ALL"]
    }
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    events.each do |event|
      text = event.message['text']
      userId = event['source']['userId']
      if text == "受け取るメンバーの設定をする"
        message = {
          "type": "text",
          "text": "hello"
        }
      else
        message = {
          "type": "text",
          "text": "こんにちは"
        }
      end
      client.push_message(userId, message)
    end
  end

  # LINEからメンバー設定のメッセージが届いたらメンバーを決めてもらう
    def setting_request
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)

    events.each do |event|
      text = event.message['text']
      userId = event['source']['userId']
      if text == "受け取るメンバーの設定をする"
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
                  "label": "高地優吾",
                  "displayText": " 高地優吾 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "京本大我",
                  "displayText": " 京本大我 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "田中樹",
                  "displayText": " 田中樹 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "松村北斗",
                  "displayText": " 松村北斗 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "ジェシー",
                  "displayText": " ジェシー さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "森本慎太郎",
                  "displayText": " 森本慎太郎 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              }
              
            ]
          }
        }
      }
      client.push_message(userId, message)
      end
    end
    head :ok
  end

  # 選択してもらったメンバーについて設定を選ぶ
def submit_setting
  body = request.body.read
  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    error 400 do 'Bad Request' end
  end
  events = client.parse_events_from(body)

  events.each do |event|
    text = event.message['text']
    userId = event['source']['userId']
    if text == " 高地優吾 さんの情報について設定する"
      name = "高地優吾" 
    elsif text == " 京本大我 さんの情報について設定する"
      name = "京本大我"
    elsif text == " 田中樹 さんの情報について設定する"
      name = "田中樹"
    elsif text == " 松村北斗 さんの情報について設定する"
      name = "松村北斗"
    elsif text == " ジェシー さんの情報について設定する"
      name = "ジェシー"
    elsif text == " 森本慎太郎 さんの情報について設定する"
      name = "森本慎太郎"
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
              "text": "通知設定"
            },
            {
              "type": "text",
              "text": "#{name}さんの通知について設定します。",
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
                "displayText": " #{name}さん の情報を受け取る",
                "data": "type=janken_result&result=gu"
              }
            },
            {
              "type": "button",
              "style": "link",
              "height": "sm",
              "action": {
                "type": "postback",
                "label": "通知を受け取らない",
                "displayText": " #{name}さん の情報を受け取らない",
                "data": "type=janken_result&result=gu"
              }
            }
          ]
        }
      }
    }
    # end
    client.push_message(userId, message)
    end
    head :ok
end


# 選んでもらった設定を定義し、完了したら通知する

  def set_member
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    
    events.each do |event|
      text = event.message['text']
      userId = event['source']['userId']
      @user = LineUser.find_by(user_id: userId)
      if text == " 高地優吾さん の情報を受け取る"
        @user.yugo_on
      elsif text == " 京本大我さん の情報を受け取る"
        @user.taiga_on
      elsif text == " 田中樹さん の情報を受け取る"
        @user.juri_on
      elsif text == " 松村北斗さん の情報を受け取る"
        @user.hokuto_on
      elsif text == " ジェシーさん の情報を受け取る"
        @user.jess_on
      elsif text == " 森本慎太郎さん の情報を受け取る"
        @user.shintarou_on
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
      client.push_message(userId, message)
    end
      head :ok
  end

  def off_member
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    
    events.each do |event|
      text = event.message['text']
      userId = event['source']['userId']
      @user = LineUser.find_by(user_id: userId)
      if text == " 高地優吾さん の情報を受け取らない"
        @user.yugo_off
      elsif text == " 京本大我さん の情報を受け取らない"
        @user.taiga_off
      elsif text == " 田中樹さん の情報を受け取らない"
        @user.juri_off
      elsif text == " 松村北斗さん の情報を受け取らない"
        @user.hokuto_off
      elsif text == " ジェシーさん の情報を受け取らない"
        @user.jess_off
      elsif text == " 森本慎太郎さん の情報を受け取らない"
        @user.shintarou_off
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
                "text": "通知しません。",
                "size": "sm",
                "flex": 12
              }
            ]
          }
        }
      }
      client.push_message(userId, message)
    end
      head :ok
  end

  def all_member_setting
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    
    events.each do |event|
      text = event.message['text']
      userId = event['source']['userId']
      @user = LineUser.find_by(user_id: userId)
      if text == "現在のメンバー設定"
        @user.yugo == "necessary" ? @y_status = "ON" : @y_status = "OFF"
        @user.taiga == "necessary" ? @t_status = "ON" : @t_status = "OFF"
        @user.juri == "necessary" ? @j_status = "ON" : @j_status = "OFF"
        @user.hokuto == "necessary" ? @h_status = "ON" : @h_status = "OFF"
        @user.jess == "necessary" ? @jess_status = "ON" : @jess_status = "OFF"
        @user.shintarou == "necessary" ? @s_status = "ON" : @s_status = "OFF"
        
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
                "text": "現在のメンバー設定一覧です。",
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
                  "label": "高地優吾  #{@y_status}",
                  "displayText": " 高地優吾 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "京本大我  #{@t_status}",
                  "displayText": " 京本大我 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "田中樹  #{@j_status}",
                  "displayText": " 田中樹 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "松村北斗  #{@h_status}",
                  "displayText": " 松村北斗 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "ジェシー  #{@jess_status}",
                  "displayText": " ジェシー さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              },
              {
                "type": "button",
                "style": "link",
                "height": "sm",
                "action": {
                  "type": "postback",
                  "label": "森本慎太郎  #{@s_status}",
                  "displayText": " 森本慎太郎 さんの情報について設定する",
                  "data": "type=janken_result&result=gu"
                }
              }
              
            ]
          }
        }
      }
      client.push_message(userId, message)
    end
    end
      head :ok
  end
end
