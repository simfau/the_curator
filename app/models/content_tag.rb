class ContentTag < ApplicationRecord
  belongs_to :content

  belongs_to :tag

  enum category: { genre: 0, mood: 1, theme: 2, other: 3 }


  def tag(content)
    reply = JSON.parse(ask_ai(content).body)
    JSON.parse(reply['choices'][0]['message']['content'] || reply['choices'][0]['message']['tool_calls'][0]['function']['arguments'])
  end


  private

  def ask_ai(content)
    Faraday.post('https://router.huggingface.co/v1/chat/completions',
      {
        messages: [
          { role: "user",
            content: "Generate tags for the following content: #{content.title} by #{content.creator}. Provide a list of relevant tags only." }
        ],
        model: "openai/gpt-oss-20b:nebius",
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

  def already_exists?(content_tag)
    if ContentTag.exists?(name: content_tag.name)
      puts "  Tag exists⏭️"
      return true
    else
      Tag.create!(name: content_tag)
      puts "  Tag created✅"
      return false
    end
  end

end
