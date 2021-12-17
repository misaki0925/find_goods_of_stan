class AddIndexUserIdToLineUsers < ActiveRecord::Migration[5.2]
  def change
    add_index :line_users, :user_id, unique: true
  end
end
