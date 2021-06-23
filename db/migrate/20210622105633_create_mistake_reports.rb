class CreateMistakeReports < ActiveRecord::Migration[5.2]
  def change
    create_table :mistake_reports do |t|
      t.string :member
      t.integer :article_id
      t.text :body

      t.timestamps
    end
  end
end
