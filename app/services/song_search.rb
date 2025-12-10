class SongSearch
  def self.run(query)
    search_tracks = RSpotify::Track.search(query)
    puts "found #{search_tracks.total} tracks"
    search_tracks.map do |track|
      unless ProviderRecord.new.already_exists?(provider_name: "Spotify", provider_content_id: track.id)
        Content.new.adding(:song, track, ProviderRecord.new)
      end
    end.compact
  rescue => e
    puts "spotify search error: #{e.message}"
  end
end
