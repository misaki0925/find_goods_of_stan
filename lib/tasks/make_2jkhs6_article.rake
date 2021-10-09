namespace :make_2jkhs6_article do
  desc '「2jkhs6」のツイートが私物に関するものかを判別し私物に関するものであれば記事を作成する'
  task account_2jkhs6: :environment do
    3.times{
      article = Article.new
      article.make_2jkhs6_article
      sleep(150)
    }
  end
end
