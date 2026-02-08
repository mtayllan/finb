require "test_helper"

class ChatMessage::TransactionParserTest < ActiveSupport::TestCase
  setup do
    @user = users(:default)
    @account = accounts(:bank_one)
    @category = categories(:food)
  end

  test "parse returns normalized transaction attributes" do
    groq_response = {
      value: -5.0,
      date: "2026-01-15",
      description: "Bread at bakery",
      account_id: @account.id,
      category_id: @category.id
    }

    stub_groq_api(groq_response)

    chat_message = ChatMessage.create!(user: @user, message: "bought bread 5 dollars")
    result = ChatMessage::TransactionParser.new(chat_message).parse

    assert_equal(-5.0, result[:value])
    assert_equal Date.new(2026, 1, 15), result[:date]
    assert_equal "Bread at bakery", result[:description]
    assert_equal @account.id, result[:account_id]
    assert_equal @category.id, result[:category_id]
  end

  test "parse raises ParseError on invalid date" do
    stub_groq_api(value: -5.0, date: "not-a-date", description: "Test", account_id: nil, category_id: nil)

    chat_message = ChatMessage.create!(user: @user, message: "test")

    error = assert_raises(ChatMessage::ParseError) do
      ChatMessage::TransactionParser.new(chat_message).parse
    end

    assert_match(/Invalid date/, error.message)
  end

  test "parse includes user accounts and categories in the prompt" do
    stub_groq_api(value: -1, date: Date.current.to_s, description: "x", account_id: nil, category_id: nil)

    chat_message = ChatMessage.create!(user: @user, message: "test")
    ChatMessage::TransactionParser.new(chat_message).parse

    request = WebMock::RequestRegistry.instance.requested_signatures.hash.keys.first
    body = JSON.parse(request.body)
    user_prompt = body["messages"].last["content"]

    assert_includes user_prompt, @account.name
    assert_includes user_prompt, @category.name
  end
end
