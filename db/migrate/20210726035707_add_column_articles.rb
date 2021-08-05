class AddColumnArticles < ActiveRecord::Migration[5.2]
  def change
    add_column :articles, :item, :string
  end
end
