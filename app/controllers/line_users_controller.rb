class LineUsersController < ApplicationController
  skip_before_action :require_login
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token

  require 'line/bot'

  def line_responce
    #LINE Messaging API認証
    line_client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
      body = request.body.read
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless line_client.validate_signature(body, signature)
        error 400 do 'Bad Request' end
      end
      #request.bodyを解析する
      events = line_client.parse_events_from(body)
      events.each do |event|
        #user_id取得
        userId = event['source']['userId']
        #event内容をtypeによって分岐させ処理する
        if event['type'] == "message"
          LineUser.return_message(userId)
        elsif event['type'] == "postback"
          data = event['postback']['data']
          if data == "start"
            LineUser.start(userId)
          elsif data == ("see_setting_member")
            LineUser.all_member_setting(userId)
          elsif data == ("recent_item")
            LineUser.recent_item(userId)
          elsif data.include?("_recent")
            LineUser.send_recent_item(data, userId)
          elsif data == ("set_member")
            LineUser.set_member(userId)
          elsif data.include?("_info")
            LineUser.settei_member(data, userId)
          elsif data.include?("on_")
            LineUser.on_info(data, userId,)
          elsif data.include?("off_")
            LineUser.off_info(data, userId)
          end
        end
      end
      head :ok
    end
  end