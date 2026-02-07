class ChatMessage::GroqClient
  API_URL = "https://api.groq.com/openai/v1/chat/completions"
  MODEL = "llama-3.1-8b-instant"

  def initialize(api_key = ENV["GROQ_API_KEY"])
    @api_key = api_key
  end

  def chat(system_prompt, user_prompt)
    raise ChatMessage::ParseError, "GROQ_API_KEY not configured" if @api_key.blank?

    uri = URI(API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 30

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{@api_key}"
    })

    request.body = {
      model: MODEL,
      messages: [
        {role: "system", content: system_prompt},
        {role: "user", content: user_prompt}
      ],
      temperature: 0.1,
      max_tokens: 300,
      response_format: {type: "json_object"}
    }.to_json

    response = http.request(request)

    unless response.code == "200"
      raise ChatMessage::ParseError, "Groq API error: #{response.body}"
    end

    parsed = JSON.parse(response.body)
    content = parsed.dig("choices", 0, "message", "content")
    raise ChatMessage::ParseError, "Empty response from Groq" if content.blank?

    JSON.parse(content)
  rescue JSON::ParserError => e
    raise ChatMessage::ParseError, "Failed to parse Groq response: #{e.message}"
  rescue Net::OpenTimeout, Net::ReadTimeout
    raise ChatMessage::ParseError, "Groq API timeout"
  end
end
