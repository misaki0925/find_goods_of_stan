class CreateArticleMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :article_members do |t|
      t.references :article, index: true, foreign_key: true
      t.references :member, index: true, foreign_key: true
      t.timestamps
    end
  end
end
