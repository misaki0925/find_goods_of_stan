class ChangeEmailOfUsers < ActiveRecord::Migration[5.2]
  # 変更内容
def up
  change_column :users, :email, :string, null: false, unique: true
end
# 変更前の状態
def down
  change_column :users, :email, :string, null: false
end
end
