namespace :make_johnnys_styling_article do
  desc '「johnnys_styling」のツイートが私物に関するものかを判別し私物に関するものであれば記事を作成する'
  task account_johnnys_styling: :environment do
    article = Article.new
    article.make_Johnnys_styling_article
  end
end
