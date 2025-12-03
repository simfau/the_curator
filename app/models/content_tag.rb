class ContentTag < ApplicationRecord
  belongs_to :content

  belongs_to :tag
end
