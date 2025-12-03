require 'faker'
require 'themoviedb'
require 'rspotify'

Content.destroy_all
ProviderRecord.destroy_all

Tmdb::Api.key(ENV["TMDB_API_KEY"])
RSpotify::authenticate(ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"])

popular_movies= Tmdb::Movie.popular
20.times do |i|
  find_movie = popular_movies[i] # get popular movies from TMDB
  if find_movie
    movie = Tmdb::Movie.detail(find_movie.id) # get detailed info for each movie
    puts "Seeding movie: #{movie['title']}"

    title = movie['title']
    description = movie['overview']
    released = movie['release_date'].first(4)
    director = Tmdb::Movie.crew(movie['id']).find { |crew| crew['known_for_department'] == "Directing" }&.[]('name')
    if director.nil?
      puts "Didnt find director for #{title}❌"
    end
    duration = movie['runtime']
    popularity = movie['popularity']
    imdb_id = movie['imdb_id']

    if movie['poster_path']
      img  = "https://image.tmdb.org/t/p/original#{movie['poster_path']}"
    else
      img = nil
      puts 'No poster available❌' #should check imdb for image
    end

    content = Content.create!(
      format: :movie,
      title: title,
      creator: director,
      description: description,
      image_url: img,
      date_of_release: released,
      duration: duration,
      popularity_score: popularity)

    puts "#{title} added to Contents✅"

    ProviderRecord.create!(
      content_id: content.id,
      provider_name: "TMDB",
      provider_content_id: movie['id']
    )

    if movie['imdb_id']
      ProviderRecord.create!(
        content_id: content.id,
        provider_name: "IMDB",
        provider_content_id: imdb_id
      )
      puts 'IMDB ID added ✅'
    end
    @movie_counter = i
  else
    puts "No movie found for index #{i}"
    break
  end
end

puts "#{@movie_counter + 1} movies seeded! 🎬🍿"

puts "Seeding songs from Spotify..."

@song_counter = 1
@song_target = 10
while @song_counter <= @song_target do
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
    @song_counter += 1
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
    ProviderRecord.create!(
      content_id: content.id,
      provider_name: "Spotify",
      provider_content_id: track.id
    )
    puts "Spotify ID added ✅"
    break if @song_counter > @song_target
  end
end
