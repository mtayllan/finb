class StatementAnalysis::PdfAnalyzer
  class DetectionError < StandardError; end

  GROQ_API_URL = "https://api.groq.com/openai/v1/chat/completions"

  def self.analyze(file, password: nil, is_credit_card: false)
    new(file, password: password, is_credit_card: is_credit_card).analyze
  end

  def initialize(file, password: nil, is_credit_card: false)
    @file = file
    @password = password
    @is_credit_card = is_credit_card
  end

  def analyze
    pdf_text = extract_text_from_pdf
    raise DetectionError, "Could not extract text from PDF" if pdf_text.blank?

    transactions = parse_with_groq(pdf_text)
    raise DetectionError, "No transactions found in PDF" if transactions.empty?

    # Return data in the same format as CsvAnalyzer for compatibility
    {
      transactions: transactions
    }
  end

  private

  def extract_text_from_pdf
    options = {}
    options[:password] = @password if @password.present?

    reader = PDF::Reader.new(@file.path, options)
    reader.pages.map(&:text).join("\n")
  rescue PDF::Reader::MalformedPDFError => e
    raise DetectionError, "Invalid PDF file: #{e.message}"
  rescue PDF::Reader::EncryptedPDFError
    raise DetectionError, "PDF is password protected. Please provide the correct password."
  end

  def parse_with_groq(text)
    api_key = ENV["GROQ_API_KEY"]
    if api_key.blank?
      raise DetectionError, "GROQ_API_KEY not configured. Please add your Groq API key to the .env file or environment variables. Get your free API key at https://console.groq.com/"
    end

    prompt = build_prompt(text)
    response = call_groq_api(api_key, prompt)

    parse_groq_response(response)
  end

  def build_prompt(text)
    value_instructions = if @is_credit_card
      <<~CREDIT_CARD
        - value (number, POSITIVE for expenses/purchases, NEGATIVE for refunds/credits)
        
        IMPORTANT: Credit card statements show expenses as POSITIVE values.
        Only refunds, credits, or payments should be negative.
      CREDIT_CARD
    else
      <<~BANK_ACCOUNT
        - value (number, NEGATIVE for expenses, POSITIVE for income)
        
        IMPORTANT: Bank statements show expenses as NEGATIVE values.
        Income and deposits should be positive.
      BANK_ACCOUNT
    end

    example_format = if @is_credit_card
      <<~EXAMPLE
        [
          {"date": "2025-01-15", "description": "Grocery Store", "value": 150.50},
          {"date": "2025-01-16", "description": "Refund - Amazon", "value": -50.00}
        ]
      EXAMPLE
    else
      <<~EXAMPLE
        [
          {"date": "2025-01-15", "description": "Grocery Store", "value": -150.50},
          {"date": "2025-01-16", "description": "Salary", "value": 5000.00}
        ]
      EXAMPLE
    end

    <<~PROMPT
      You are a financial transaction parser. Extract all transactions from this #{@is_credit_card ? "credit card" : "bank"} statement.

      Statement text:
      #{text}

      Return ONLY a valid JSON array of transactions. Each transaction must have:
      - date (format: YYYY-MM-DD)
      - description (string)
      #{value_instructions.strip}

      Example format:
      #{example_format.strip}

      Important:
      - Return ONLY the JSON array, no additional text
      - Parse all dates to YYYY-MM-DD format
      - Keep the sign convention as described above
    PROMPT
  end

  def call_groq_api(api_key, prompt)
    uri = URI(GROQ_API_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.read_timeout = 60

    request = Net::HTTP::Post.new(uri.path, {
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{api_key}"
    })

    request.body = {
      model: "llama-3.3-70b-versatile",
      messages: [
        {role: "user", content: prompt}
      ],
      temperature: 0.1,
      max_tokens: 4000
    }.to_json

    response = http.request(request)

    unless response.code == "200"
      raise DetectionError, "Groq API error: #{response.body}"
    end

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    raise DetectionError, "Failed to parse Groq response: #{e.message}"
  rescue Net::ReadTimeout
    raise DetectionError, "Groq API timeout - PDF might be too large"
  end

  def parse_groq_response(response)
    content = response.dig("choices", 0, "message", "content")
    raise DetectionError, "Empty response from Groq" if content.blank?

    # Extract JSON from response (in case there's additional text)
    json_match = content.match(/\[.*\]/m)
    raise DetectionError, "Could not find JSON array in response" unless json_match

    transactions = JSON.parse(json_match[0])

    # Validate and normalize transactions
    transactions.map do |t|
      {
        date: Date.parse(t["date"]),
        description: t["description"].to_s.strip,
        value: t["value"].to_f
      }
    end
  rescue JSON::ParserError => e
    raise DetectionError, "Failed to parse transactions JSON: #{e.message}"
  rescue Date::Error => e
    raise DetectionError, "Invalid date in transaction: #{e.message}"
  end
end
