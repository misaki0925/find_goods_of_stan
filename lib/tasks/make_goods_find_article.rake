namespace :make_goods_find_article do
  desc '「GoodsFind」のツイートが私物に関するものかを判別し私物に関するものであれば記事を作成する'
  task account_goods_find: :environment do
    3.times{
      article = Article.new
      article.make_GoodsFind_article
      sleep(150)
    }
  end
end
