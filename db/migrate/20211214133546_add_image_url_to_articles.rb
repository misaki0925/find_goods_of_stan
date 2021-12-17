class AddImageUrlToArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :line_image_url, :text
  end
end
