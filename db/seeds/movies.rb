def seed_movies(target)
  movies_counter = 0
  skipped_songs = 0
  popular_movies = Tmdb::Movie.popular # prepare first batch of movies from TMDB
  puts "found #{popular_movies.size} popular movies from TMDB"
  more_movies(popular_movies)
  loop_seed_movies(target, movies_counter, skipped_songs, popular_movies)
end

def more_movies(random_movies)
  # fetch more movies from TMDB if we run out (we only get 20 at a time)
  if random_movies.size == 0
    until random_movies&.any?
      #get a random movie from our db to get new recommendations based on it v
      rand_movie_from_db = Content.where(format: :movie).sample
      # just to be very safe v
      next unless rand_movie_from_db && rand_movie_from_db.id.present?
      begin # prepare for possible errors from TMDB API
        # puts "Fetching more movies... #{ movies_counter - skipped_songs}/#{target} based on recommendations from #{rand_movie_from_db.title}🍿"
        random_movies = Tmdb::Movie.similar_movies(rand_movie_from_db.id, page: rand(1..10))
      rescue StandardError => e # fallback in case of error from TMDB (idk why it happens so often)
        puts "Error fetching similar movies for #{rand_movie_from_db.title}: #{e.message} ❌"
        random_movies = nil
      end
      if random_movies&.any?
        puts "Found #{random_movies.size} more movies from TMDB"
      else
        puts "No similar movies found for #{rand_movie_from_db.title} (ID: #{rand_movie_from_db['id']}), trying another..."
      end
    end
  end
  random_movies
end


def loop_seed_movies(target, movies_counter, skipped_movies, random_movies)
  # loop until we reach ourtarget number of new movies added
  while  movies_counter - skipped_movies <= target - 1 do
    #if we run out v
    more = more_movies(random_movies)
    random_movies = more if more
    find_movie = random_movies[movies_counter % random_movies.size]
    if find_movie
      if ProviderRecord.exists?(provider_name: "TMDB", provider_content_id: Tmdb::Movie.detail(find_movie.id)['id'])
        puts "Movie #{find_movie.id} already exists, skipping...⏭️"
        random_movies.delete_at( movies_counter % random_movies.size)
        movies_counter += 1
        skipped_movies += 1
      else
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
        more_movies(random_movies)
        movies_counter += 1
      end
    else
      puts "No movie found for index #{ movies_counter}"
      random_movies.delete_at(movies_counter % random_movies.size)
      skipped_movies += 1
      movies_counter += 1
      break
    end
  end
  puts "Skipped #{skipped_movies} movies due to duplicates."
  puts "#{ movies_counter} movies processed."
  puts "#{ movies_counter - skipped_movies} movies seeded! 🎬🍿"
end
