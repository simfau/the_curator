require 'faker'
require 'themoviedb'
require 'rspotify'
require_relative 'seeds/movies'
require_relative 'seeds/songs'

# ProviderRecord.destroy_all
# ContentTag.destroy_all
# Content.destroy_all

@content = Content.new
@provider_record = ProviderRecord.new


target = 500 #set target number of entries to add for each format

# seed_movies(target)

# seed_songs(target)

skipped_tags = 0
tags_counter = 0

while  tags_counter - skipped_tags <= target * 2 do
  content = Content.all.where(is_processed: nil).order(popularity_score: :desc)[tags_counter]
  break if content == nil
  tags_counter += 1
  if !ContentTag.new.tagging(content)
    skipped_tags += 1
    print "🔒
"
  end
end
