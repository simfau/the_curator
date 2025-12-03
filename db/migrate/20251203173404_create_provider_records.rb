class CreateProviderRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :provider_records do |t|
      t.string :provider_name
      t.string :provider_content_id

      t.references :content, null: false, foreign_key: true

      t.timestamps
    end
  end
end
