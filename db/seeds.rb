require 'faker'
require 'themoviedb'
require 'rspotify'

Content.destroy_all

Tmdb::Api.key(ENV["TMDB_API_KEY"])
RSpotify::authenticate(ENV["SPOTIFY_KEY"], ENV["SPOTIFY_SECRET"])

10.times do |i|
  # faker_movie = Faker::Movie.title

  find_movie = Tmdb::Movie.popular[i] # get popular movies from TMDB
  movie = Tmdb::Movie.detail(find_movie.id) # get detailed info for each movie
  puts "Seeding movie: #{movie.title}"

  title = movie.title
  description = movie.overview
  released = Tmdb::Movie.find(faker_movie)[0].release_date.first(4)
  director = Tmdb::Movie.crew(movie.id).find { |crew| crew.known_for_department == "Directing" }&.name || "Unknown"
  duration = movie.runtime
  popularity = movie.popularity
  imdb_id = movie.imdb_id

  if movie.poster_path
    img  = "https://image.tmdb.org/t/p/original#{movie.poster_path}"
  else
    img = nil
    puts 'No poster available' #should check imdb for image
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

  puts "#{title} added to Contents"

  ProviderRecords.create!(
    content_id: content.id,
    provider_name: "TMDB",
    provider_content_id: movie.id
  )

  if movie.imdb_id
    ProviderRecords.create!(
      content_id: content.id,
      provider_name: "IMDB",
      provider_content_id: imdb_id
    )
    puts 'IMDB ID added'
  end
end
