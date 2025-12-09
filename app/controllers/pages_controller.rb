require 'ruby_llm'

class PagesController < ApplicationController
  def home

  end
  def contents_search
    if params[:query].present?
      @contents = Content.search_by_title_creator_description(params[:query]).limit(9)
    else
      @contents = Content.all.shuffle.first(9)
    end
  end
  def recommendation
    params[:action_type] == 'movie' ? format = 1 : format = 0
    @content = Content.contents_score(params[:content_ids].flatten, format).first
    contents = params[:content_ids].flatten.map {|content_id| Content.find(content_id)}
    @explanation = JSON.parse(explanation(contents, @content).body)['choices'][0]['message']['content']
    # @content = @contents.select{ |content| content[:content][:format] == params[:action_type] }.first
  end

  def explanation(contents, result)
    @ai_model = "openai/gpt-oss-20b:groq"
    Faraday.post('https://router.huggingface.co/v1/chat/completions',
      {
        messages: [
          { role: "user",
            content: "the user loved : #{(contents.map.with_index { |content, index| "##{index}:
Title: #{content[:title]}#{",
Creator: #{content[:creator]}" if content[:creator]},
Year: #{content[:date_of_release]} (#{content[:format]})" }).join(", ")}.

Recommend this #{result[:content].format}: title: #{result[:content].title}#{", Creator: #{result[:content].creator}" if result[:content].creator}, Year: #{result[:content].date_of_release}.
Explain this recommendation and dont change it. keep it under 100 words and dont think too long"
        }],
        model: @ai_model,
        stream: false,
        temperature: 0.7,
        max_tokens: 16096,
        top_p: 0.71
      }.to_json,
      {
        "Authorization" => "Bearer #{ENV['HF_TOKEN']}",
        "Content-Type" => "application/json"
      }
    )
  end
end
