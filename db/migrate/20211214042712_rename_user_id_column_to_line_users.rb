class RenameUserIdColumnToLineUsers < ActiveRecord::Migration[5.2]
  def change
    rename_column :line_users, :user_id, :line_user_id
  end
end
