class LinebothokutoController < ApplicationController
  require 'line/bot'

  protect_from_forgery :except => [:callback]

def callback
  client = Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID_HM"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET_HM"]
    config.channel_token = ENV["LINE_CHANNEL_TOKEN_HM"]
  }

  body = request.body.read

  signature = request.env['HTTP_X_LINE_SIGNATURE']
  unless client.validate_signature(body, signature)
    head :bad_request
  end

  #@article=Article.order(created_at: :desc).limit(1)
  events = client.parse_events_from(body)
  # ユーザーへメッセージを送付する
  events.each {|event|
  message = {
    type: 'text',
    text: "6人の情報をお送りします。"
      } 
  client.push_message(event['source']['userId'], message)
    }
  end
end
