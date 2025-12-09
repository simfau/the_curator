class DeleteBadContent < ActiveRecord::Migration[7.1]
  def up
    Content.where.missing(:content_tags).destroy_all
  end

  def down
  end
end
