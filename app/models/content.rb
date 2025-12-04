class Content < ApplicationRecord
  has_many :content_tags, dependent: :destroy

  has_many :provider_records, dependent: :destroy

  enum format: [:song, :movie]

  def adding(type, content, provider_record = ProviderRecord.new) #i think it's faster not to make one each time
    case type
    when :song
      puts "#{content.name}"
      if content.album.images.any?
        img = content.album.images.first['url']
      else
        img = nil
        puts "  No album❌" if img.nil?
      end

      added = Content.create!(
        format: :song,
        title: content.name,
        creator: content.artists.map(&:name).join(", "),
        description: nil, #could an ai do it? or other api? TODO
        image_url: img,
        date_of_release: content.album.release_date.first(4),
        duration: content.duration_ms / 1000,
        popularity_score: content.popularity
      )

      provider_ids = []
      provider_ids << { provider_name: "Spotify", provider_content_id: content.id }
      provider_record.adding(provider_ids, added)

      puts " done✅"

    when :movie
      puts "#{content['title']}"
      director = Tmdb::Movie.crew(content['id']).find { |crew| crew['known_for_department'] == "Directing" }&.[]('name')
      puts "  No director❌" if director.nil?

      if content['poster_path']
        img  = "https://image.tmdb.org/t/p/original#{content['poster_path']}"
      else
        img = nil
        puts "  No poster❌" #should check imdb for image
      end

      added = Content.create!(
        format: :movie,
        title: content['title'],
        creator: director,
        description: content['overview'],
        image_url: img,
        date_of_release: content['release_date'].first(4),
        duration: content['runtime'],
        popularity_score: content['popularity']
      )

      provider_ids = []

      provider_ids << { provider_name: "TMDB", provider_content_id: content['id'] }
      imdb_id = content['imdb_id']
      if imdb_id
        provider_ids << { provider_name: "IMDB", provider_content_id: imdb_id }
      end

      provider_record.adding(provider_ids, added)

      puts " done✅"
    else
      raise "Unsupported type: #{type}❌"
    end
  end

end
