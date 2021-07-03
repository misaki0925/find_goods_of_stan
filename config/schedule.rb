# Rails.rootを使用するために必要

require File.expand_path(File.dirname(__FILE__) + '/environment')

# cronを実行する環境変数

rails_env = ENV['RAILS_ENV'] || :development

# cronを実行する環境変数をセット

set :environment, rails_env

# cronのログの吐き出し場所

set :output, "#{Rails.root}/log/cron.log"

# rakeタスクを5分ごとに実行

every 5.minute do

rake 'tweet_url:get_tweet_url'

end