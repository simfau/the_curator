class DeleteBadContent < ActiveRecord::Migration[7.1]
  def up
    Content.where.missing(:content_tags).destroy_all
    Content.where(image_url: nil).destroy_all
    puts "done"
  end

  def down
    puts "cant roll back a clean up"
  end
end
