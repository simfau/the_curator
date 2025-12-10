class MovieSearch
  def self.run(query)
    movies = Tmdb::Search.new.resource("movie").query(query).fetch
    movies.map do |movie|
      movie_details = Tmdb::Api.get("/movie/#{movie['id']}", query: Tmdb::Api.config.merge(append_to_response: "credits"))
      unless ProviderRecord.new.already_exists?(provider_name: "TMDB", provider_content_id: movie['id'])
          Content.new.adding(:movie, movie_details, ProviderRecord.new)
      end
    end.compact
  rescue => e
    puts "movie search error: #{e.message}"
  end
end
