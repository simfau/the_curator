class ContentTag < ApplicationRecord
  belongs_to :content

  belongs_to :tag

enum category: {
  mood: 0,                # Emotional response
  theme: 1,               # Central ideas
  atmosphere: 2,          # Overall tone/vibe (replaces `tone`)
  pacing: 3,              # Temporal flow
  narrative_structure: 4, # Storytelling approach
  aesthetic_style: 5,     # Aesthetic qualities (replaces `visual_style`, `texture`, `color_palette`)
  philosophy: 6,          # Underlying ideas/worldviews
  cultural_context: 7,
  unknown: 8,
  emotion: 9
}

  def tagging(content = nil)
    @ai_model = "openai/gpt-oss-20b:groq"
    return if content == nil
    if content.is_processed == nil
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
          puts "try ##{i}
"
          if i > 2
            puts reply
            @ai_model = "openai/gpt-oss-20b:nebius"
            puts "changing inference provider for the next one ⏱️"
          end
        end
      end
      if save_tags(parsed, content)
        return true
      else
        return false
      end
    else
      print "🔒#{content.id}"
      return false
    end
  end

  def ask_ai(content)
    Faraday.post('https://router.huggingface.co/v1/chat/completions',
      {
        messages: [
          { role: "user",
            content: "Generate short (one or two words) tags for the following #{content.format}: #{content.title} by #{content.creator} from #{content.date_of_release} using the 'tags-from-content' tool. Do not include any extra text or reasoning in the output. Distribute exactly 50 tags as you wish in the categories." }
        ],
        model: @ai_model,
        stream: false,
        tools: [JSON_SCHEMA],
        temperature: 0.7,
        max_tokens: 16182,
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
            print "🏳️"
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
    if count == 0
      puts "0️⃣"
      false
    else
      content.is_processed = Time.now
      if content.save
        print " 🔗"
        puts "
#{count} 🏷️"
        return true
      end
    end
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
