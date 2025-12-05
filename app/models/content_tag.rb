class ContentTag < ApplicationRecord
  belongs_to :content

  belongs_to :tag

  enum category: {
  mood: 0,
  tone: 1,
  theme: 2,
  philosophy: 3,
  energy_level: 4,
  pacing: 5,
  narrative_structure: 6,
  emotional_arc: 7,
  visual_style: 8,
  color_palette: 9,
  texture: 10,
  cultural_context: 11,
  genre: 12,
  technique: 13,
  complexity: 14,
  originality: 15,
  unknown: 16
}
  def tagging(content = nil)
    return if content == nil
    parsed = nil
    i = 1
    until parsed
      reply = nil
      until reply do
        reply = JSON.parse(ask_ai(content).body)
      end
      begin
        parsed = JSON.parse(reply['choices'][0]['message']['content'] || reply['choices'][0]['message']['tool_calls'][0]['function']['arguments'])
      rescue => e
        puts "ai failed: #{e.message}"
        i += 1
        puts "try nb:#{i}"
        if i > 5
          puts reply
        end
      end
    end
    save_tags(parsed, content)
  end

  def ask_ai(content)
    Faraday.post('https://router.huggingface.co/v1/chat/completions',
      {
        messages: [
          { role: "user",
            content: "Generate tags for the following content: #{content.title} by #{content.creator} from #{content.date_of_release}. There should be 50 tags, " }
        ],
        model: "openai/gpt-oss-20b:groq",
        stream: false,
        tools: [JSON_SCHEMA],
        temperature: 0.7,
        max_tokens: 8096,
        top_p: 0.71
      }.to_json,
      {
        "Authorization" => "Bearer #{ENV['HF_TOKEN']}",
        "Content-Type" => "application/json"
      }
    )
  end

  def find_tag(content_tag)
    if tag = Tag.find_by(name: content_tag)
      print "⏭️"
      return tag.id
    else
      tag = Tag.create!(name: content_tag)
      print "🛟"
      return tag.id
    end
  end

  def category=(value)
    super(if self.class.categories.key?(value.to_s)
            value
          else
            print "⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️⁇🏳️"
            :unknown
          end)
  end

  def save_tags(parsed_reply, content)
    count = 0
    puts content.id
    parsed_reply.each do |_, categories|
      categories.each do |category|
        category[1].each do |tag|
        if count % 10 == 0 && count != 0
          puts ""
        end
        # print "  #{tag}"
        count += 1
        new_tag = ContentTag.create!(tag_id: find_tag(tag), content_id: content.id, category: category[0].to_sym)
        # binding.irb
        new_tag.save
      end
    end
    end

    content.is_processed = Time.now
    if content.save
      print " 🔗"
    end
    puts "
#{count} total🏷️
    "
  end
  # content = Content.first
  # reply = JSON.parse(ContentTag.new.ask_ai(content).body)
  # JSON.parse(reply['choices'][0]['message']['content'] || reply['choices'][0]['message']['tool_calls'][0]['function']['arguments'])

  # content = Content.all.sample
  # reply = ContentTag.new.tag(content)
  # reply['tags']
  #

  # content = Content.all.sample
  # ContentTag.new.tag(content)
end
