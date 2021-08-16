crumb :root do
  link "トップページ", root_path
end
crumb :articles do
  link "記事一覧" , articles_path
  parent :root
end
crumb :article_show do |article|
  link "記事詳細" , article_path(article)
  parent :articles
end
crumb :new_report do
  link "報告画面" , new_report_path
  parent :root
end
