class CreateContentTags < ActiveRecord::Migration[7.1]
  def change
    create_table :content_tags do |t|
      t.references :content, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
