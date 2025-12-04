class Content < ApplicationRecord
  has_many :content_tags, dependent: :destroy

  has_many :provider_records, dependent: :destroy

  include PgSearch::Model
  pg_search_scope :search_by_title_description_creator,
    against: [ :title, :description, :creator],
    using: {
      tsearch: { prefix: true }
    }
    enum format: [:song, :movie]
end
