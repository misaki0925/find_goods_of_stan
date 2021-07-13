class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.integer :yugo_type, null: false, default: 0
      t.integer :taiga_type, null: false, default: 0
      t.integer :juri_type, null: false, default: 0
      t.integer :hokuto_type, null: false, default: 0
      t.integer :jesse_type, null: false, default: 0
      t.integer :shintaro_type, null: false, default: 0
      t.text :url, null: false

      t.timestamps
    end
  end
end
