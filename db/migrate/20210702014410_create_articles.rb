class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :member_id
      t.text :url

      t.timestamps
    end
  end
end
