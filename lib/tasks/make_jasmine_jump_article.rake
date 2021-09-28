namespace :make_jasmine_jump_article do
  desc '「jasmine_jump」のツイートが私物に関するものかを判別し私物に関するものであれば記事を作成する'
  task account_jasmine_jump: :environment do
    article = Article.new
    article.make_jasmine_jump_article
  end
end
