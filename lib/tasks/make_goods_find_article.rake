namespace :make_goods_find_article do
  desc '「GoodsFind」のツイートが私物に関するものかを判別し私物に関するものであれば記事を作成する'
  task account_goods_find: :environment do
    article = Article.new
    article.make_GoodsFind_article
  end
end
