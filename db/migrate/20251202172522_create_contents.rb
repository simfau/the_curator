class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.string :description, null: false
      t.integer :format, null: false
      t.boolean :is_processed, default: false, null: false

      t.timestamps
    end
  end
end
