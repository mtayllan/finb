class ChatMessage::TransactionParser
  SYSTEM_PROMPT = "You are a financial transaction parser. Always return valid JSON only."

  def initialize(chat_message)
    @chat_message = chat_message
    @user = chat_message.user
  end

  def parse
    prompt = build_prompt
    data = ChatMessage::GroqClient.new.chat(SYSTEM_PROMPT, prompt)

    normalize(data)
  end

  private

  def build_prompt
    accounts = @user.accounts.pluck(:id, :name, :kind)
    categories = @user.categories.pluck(:id, :name)

    accounts_list = accounts.map { |id, name, kind| "#{id}: #{name} (#{kind})" }.join("\n")
    categories_list = categories.map { |id, name| "#{id}: #{name}" }.join("\n")

    <<~PROMPT
      You are a financial transaction parser. Parse the user's natural language message into transaction data.

      User message: "#{@chat_message.message}"

      Available accounts:
      #{accounts_list}

      Available categories:
      #{categories_list}

      Return ONLY a valid JSON object with:
      - value (number, NEGATIVE for expenses, POSITIVE for income)
      - date (format: YYYY-MM-DD, default to today: #{Date.current})
      - description (string, clean and concise)
      - account_id (integer or null if not specified/unclear)
      - category_id (integer or null if not specified/unclear)

      Example input: "bought bread at bakery today 5 dollars"
      Example output: {"value": -5.00, "date": "#{Date.current}", "description": "Bread at bakery", "account_id": null, "category_id": 1}

      Important:
      - Return ONLY the JSON object, no additional text
      - Expenses must be negative values
      - Income must be positive values
      - Use best judgment to match account/category names
      - If unclear, return null for account_id or category_id
    PROMPT
  end

  def normalize(data)
    {
      value: data["value"].to_f,
      date: Date.parse(data["date"]),
      description: data["description"].to_s.strip,
      account_id: data["account_id"],
      category_id: data["category_id"]
    }
  rescue Date::Error => e
    raise ChatMessage::ParseError, "Invalid date: #{e.message}"
  end
end
