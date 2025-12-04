def seed_songs(target)
  song_counter = 0
  puts "Seeding songs from Spotify..."
while song_counter <= target - 1 do
  search_tracks = RSpotify::Track.search('pop', offset: rand(100))
  puts "Fetched #{search_tracks.total} tracks from Spotify"
  search_tracks.total.times do |j|
    track = RSpotify::Track.find(search_tracks[j].id)
    puts "Seeding song: #{track.name}"
    title = track.name
    description = nil #could an ai do it? or other api?
    released = track.album.release_date.first(4)
    artist = track.artists.map(&:name).join(", ")
    duration = track.duration_ms / 1000 # convert ms to seconds
    popularity = track.popularity
    if track.album.images.any?
      img = track.album.images.first['url']
    else
      img = nil
      puts 'No album art available❌' # should check elsewhere for image
    end
    content = Content.create!(
      format: :song,
      title: title,
      creator: artist,
      description: description,
      image_url: img,
      date_of_release: released,
      duration: duration,
      popularity_score: popularity)
    puts "#{title} added to Contents✅"
    song_counter += 1
    ProviderRecord.create!(
      content_id: content.id,
      provider_name: "Spotify",
      provider_content_id: track.id
    )
    puts "Spotify ID added ✅"
    break if song_counter >= target
  end
end
puts "#{song_counter} songs seeded! 🎬🍿"
end
