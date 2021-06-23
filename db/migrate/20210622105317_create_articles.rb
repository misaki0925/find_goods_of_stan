class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :member_id
      t.integer :category_id
      t.integer :user_id
      t.string :brand
      t.text :url

      t.timestamps
    end
  end
end
