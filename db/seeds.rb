require 'faker'
require 'themoviedb'
require 'rspotify'
require_relative 'seeds/movies'
require_relative 'seeds/songs'

# ProviderRecord.destroy_all
# ContentTag.destroy_all
# Content.destroy_all

# make sure you have your API keys set in your .env file
Tmdb::Api.key(ENV["TMDB_API_KEY"])
RSpotify::authenticate(ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"])

@content = Content.new
@provider_record = ProviderRecord.new


target = 10 #set target number of entries to add for each format

seed_movies(target)

seed_songs(target)


skipped_tags = 0
tags_counter = 0

# while  tags_counter - skipped_tags <= target do
#   content = Content.all.where(is_processed: nil).sample
#   break if content == nil
#   tags_counter += 1
#   if !ContentTag.new.tagging(content)
#     skipped_tags += 1
#     print "🔒
# "
#   end
# end
