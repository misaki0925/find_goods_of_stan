namespace :tweet_url do
  desc '5分に1回指定のタグを検索し、保存されていないURLであれば保存する'
  task get_tweet_url: :environment do
    get_url
  end
end
