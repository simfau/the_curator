require 'ruby_llm'

class Content < ApplicationRecord
  has_many :content_tags, dependent: :destroy

  has_many :provider_records, dependent: :destroy

  enum format: [:song, :movie]

  include PgSearch::Model
  pg_search_scope :search_by_title_creator_description,
    against: {
    title: 'A',   # high priority
    creator: 'B',  # mid priority
    description: 'C' #low priority
  },
    using: {
      tsearch: { prefix: true }
    }
    #, ranked_by: "CASE WHEN format = 0 THEN :tsearch * popularity_score WHEN format = 1 THEN :tsearch * popularity_score / 50 END"

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
      return added
    when :movie

      puts "#{content['title']}"
      crew = (if content['credits']
        content['credits']['crew']
      else
        Tmdb::Movie.crew(content['id'])
      end)
      director = crew.find { |crew| crew['known_for_department'] == "Directing" }&.[]('name')

      puts "  No director❌" if director.nil?
      if content['poster_path']
        img = "https://image.tmdb.org/t/p/original#{content['poster_path']}"
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
      # process(added)
      puts " done✅"
      return added
    else
      raise "Unsupported type: #{type}❌"
    end
  end

  def self.contents_score(content_ids, format)
    contents_scores = content_ids.map.with_index do |id, index|
      "contents_score(results.tag_ids, #{id}) AS content_#{index+1}"
    end

    column_names = content_ids.map.with_index do |_, index|
      "content_#{index+1}"
    end

    content_ids_str = content_ids.join(",")

    sql = <<-SQL
      SELECT id, format, (#{column_names.join(" + ")}) AS combined
      FROM (
        SELECT results.id, results.format,
          #{contents_scores.join(",")}
        FROM (
          SELECT contents.id, contents.format, array_agg(content_tags.tag_id) AS tag_ids
          FROM contents
          JOIN content_tags ON contents.id = content_tags.content_id
          GROUP BY contents.id, contents.format
        ) AS results
      ) AS list_of_results
      WHERE id NOT IN (#{content_ids_str})
        AND format = ?
      ORDER BY combined DESC
    SQL

    # Execute with ActiveRecord
    results = ActiveRecord::Base.connection.exec_query(
      ActiveRecord::Base.sanitize_sql_array([sql, format])
    )

    results.map do |h|
      {
        content: Content.find(h["id"]),
        score: h["combined"],
        # score: 100 * Math.log(((h["combined"]/content_ids.length)) * 10000 + 1, 10001)
      }
    end
  end



  private

  def describe(content)
    #call the ruby llm here to generate description
  end

  def process(content)
    if content.is_processed.nil?
      ContentTag.new.tagging(content)
      # create ContentTag records (or call ContentTag method to do so)
      # content.update!(is_processed: Time.now)
    end
  end

end
