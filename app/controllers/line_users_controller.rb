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
                  "label": " 高地優吾",
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
                  "label": " 京本大我",
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
                  "label": " 田中樹",
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
                  "label": " 松村北斗",
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
                  "label": " ジェシー",
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
                  "label": " 森本慎太郎",
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
        name = "高地優吾" 
        @user.yugo_necessary! if @user.yugo_unnecessary?
      elsif text == " 京本大我さん の情報を受け取る"
        name = "京本大我"
        @user.taiga_necessary! if @user.taiga_unnecessary?
      elsif text == " 田中樹さん の情報を受け取る"
          name = "田中樹"
          @user.juri_necessary! if @user.juri_unnecessary?
      elsif text == " 松村北斗さん の情報を受け取る"
          name = "松村北斗"
          @user.hokuto_necessary! if @user.hokuto_unnecessary?
      elsif text == " ジェシーさん の情報を受け取る"
          name = "ジェシー"
          @user.jess_necessary! if @user.jess_unnecessary?
      elsif text == " 森本慎太郎さん の情報を受け取る"
          name = "森本慎太郎"
          @user.shintarou_necessary! if @user.shintarou_unnecessary?
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
                "text": "#{name}さんの情報について",
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
        name = "高地優吾" 
        @user.yugo_unnecessary! if @user.yugo_necessary?
      elsif text == " 京本大我さん の情報を受け取らない"
        name = "京本大我"
        @user.taiga_unnecessary! if @user.taiga_necessary?
      elsif text == " 田中樹さん の情報を受け取らない"
          name = "田中樹"
          @user.juri_unnecessary! if @user.juri_necessary?
      elsif text == " 松村北斗さん の情報を受け取らない"
          name = "松村北斗"
          @user.hokuto_unnecessary! if @user.hokuto_necessary?
      elsif text == " ジェシーさん の情報を受け取らない"
          name = "ジェシー"
          @user.jess_unnecessary! if @user.jess_necessary?
      elsif text == " 森本慎太郎さん の情報を受け取らない"
          name = "森本慎太郎"
          @user.shintarou_unnecessary! if @user.shintarou_necessary?
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
                "text": "#{name}さんの情報について",
                "size": "md",
                "flex": 12
              },
              {
                "type": "text",
                "text": "通知しません。",
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
end
