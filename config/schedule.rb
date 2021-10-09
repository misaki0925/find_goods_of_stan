# Rails.rootを使用するために必要
require File.expand_path(File.dirname(__FILE__) + '/environment')
# cronを実行する環境変数
rails_env = ENV['RAILS_ENV'] || :development
# cronを実行する環境変数をセット
set :environment, rails_env
# cronのログの吐き出し場所
set :output, "#{Rails.root}/log/cron.log"
# 1分ごとに実行
# every 1.minute do
#   rake "make_goods_find_article:account_goods_find"
# end
# every 1.minute do
#   rake "make_2jkhs6_article:account_2jkhs6"
# end
every 1.minute do
  rake "make_johnnys_styling_article:account_johnnys_styling"
end
every 1.minute do
  rake "make_jasmine_jump_article:account_jasmine_jump"
end
