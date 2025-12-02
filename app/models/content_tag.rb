class ContentTag < ApplicationRecord
  belongs_to :content_id
  belongs_to :tag_id
end
