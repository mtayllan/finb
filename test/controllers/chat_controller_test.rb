require "test_helper"

class ChatControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
    @user = users(:default)
    @account = accounts(:bank_one)
    @category = categories(:food)
  end

  test "index displays chat messages" do
    get chat_index_path

    assert_response :success
    assert_select "div.chat-bubble", text: chat_messages(:greeting).message
  end

  test "create rejects empty messages" do
    assert_no_difference "ChatMessage.count" do
      post chat_index_path, params: {message: "  "}
    end

    assert_redirected_to chat_index_path
    assert_equal "Message can't be blank", flash[:alert]
  end

  test "create creates transaction and saves response" do
    stub_groq_api(
      value: -10.0,
      date: Date.current.to_s,
      description: "Test transaction",
      account_id: @account.id,
      category_id: @category.id
    )

    assert_difference ["ChatMessage.count", "Transaction.count"], 1 do
      post chat_index_path, params: {message: "test message"}
    end

    assert_redirected_to chat_index_path
    assert_equal "Transaction created!", flash[:notice]

    chat_message = ChatMessage.last
    assert_equal "test message", chat_message.message
    assert_not_nil chat_message.response
    assert_not_nil chat_message.created_transaction
  end

  test "create saves chat message even on parse error" do
    original_key = ENV["GROQ_API_KEY"]
    ENV["GROQ_API_KEY"] = nil

    assert_difference "ChatMessage.count", 1 do
      assert_no_difference "Transaction.count" do
        post chat_index_path, params: {message: "test message"}
      end
    end

    chat_message = ChatMessage.last
    assert_equal "test message", chat_message.message
    assert_match(/GROQ_API_KEY not configured/, chat_message.response)
  ensure
    ENV["GROQ_API_KEY"] = original_key
  end
end
