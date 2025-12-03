class CreateContents < ActiveRecord::Migration[7.1]
  def change
    create_table :contents do |t|
      t.integer :format
      t.string :title
      t.date :date_of_release
      t.string :creator
      t.text :description
      t.integer :duration
      t.string :image_url
      t.float :popularity_score
      t.datetime :is_processed

      t.timestamps
    end
  end
end
