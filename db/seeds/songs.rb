def seed_songs(target)
  song_counter = 0
  skipped_songs = 0
  puts "Seeding songs from Spotify..."
while song_counter - skipped_songs <= target - 1 do
  search_tracks = RSpotify::Track.search('rock', offset: rand(1000))
  puts "found #{search_tracks.total} tracks"
  search_tracks.total.times do |j|
    track = RSpotify::Track.find(search_tracks[j]&.id)
    if track
      if @provider_record.already_exists?(provider_name: "Spotify", provider_content_id: track.id)
        song_counter += 1
        skipped_songs += 1
        search_tracks.delete(j)
        # puts "skipping (#{skipped_songs})"
      else
        @content.adding(:song, track, @provider_record)
        song_counter += 1
        # puts "adding (#{song_counter})"
      end
    end
    break if song_counter - skipped_songs >= target
  end
end
  puts "#{ skipped_songs } duplicates⏭️"
  puts "#{ song_counter} processed."
  puts "#{ song_counter - skipped_songs} seeded! 🎶🎧"
end
