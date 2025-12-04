class AddCategoryColumnToContentTags < ActiveRecord::Migration[7.1]
  def change
    add_column :content_tags, :category, :integer
    #will be enums
  end
end
