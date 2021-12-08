class CreateLineUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :line_users do |t|
      t.string :user_id, null: false
      t.integer :yugo, null: false, default: 0
      t.integer :taiga, null: false, default: 0
      t.integer :juri, null: false, default: 0
      t.integer :hokuto, null: false, default: 0
      t.integer :jess, null: false, default: 0
      t.integer :shintarou, null: false, default: 0

      t.timestamps
    end
  end
end
