class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :price
      t.string :brand
      t.text :tweet_url, null: false, unique: true
      t.timestamps
    end
  end
end
