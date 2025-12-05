require 'faker'
require 'themoviedb'
require 'rspotify'
require_relative 'seeds/movies'
require_relative 'seeds/songs'

# make sure you have your API keys set in your .env file
Tmdb::Api.key(ENV["TMDB_API_KEY"])
RSpotify::authenticate(ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"])

@content = Content.new
@provider_record = ProviderRecord.new

# ProviderRecord.destroy_all
# ContentTag.destroy_all
# Content.destroy_all

target = 10 #set target number of entries to add for each format

# seed_movies(target)

seed_songs(target)
