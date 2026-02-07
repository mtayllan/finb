require "test_helper"

class ChatMessage::GroqClientTest < ActiveSupport::TestCase
  setup do
    @client = ChatMessage::GroqClient.new("test-api-key")
  end

  test "chat returns parsed JSON from API response" do
    expected = {"value" => -5.0, "description" => "Coffee"}

    stub_groq_api(expected)

    result = @client.chat("system prompt", "user prompt")

    assert_equal expected, result
  end

  test "chat raises ParseError when API key is blank" do
    client = ChatMessage::GroqClient.new(nil)

    error = assert_raises(ChatMessage::ParseError) do
      client.chat("system", "user")
    end

    assert_equal "GROQ_API_KEY not configured", error.message
  end

  test "chat raises ParseError on non-200 response" do
    stub_groq_api_error(status: 500, body: "Internal Server Error")

    error = assert_raises(ChatMessage::ParseError) do
      @client.chat("system", "user")
    end

    assert_match(/Groq API error/, error.message)
  end

  test "chat raises ParseError on timeout" do
    stub_groq_api_timeout

    error = assert_raises(ChatMessage::ParseError) do
      @client.chat("system", "user")
    end

    assert_equal "Groq API timeout", error.message
  end

  test "chat raises ParseError when response content is empty" do
    response_body = {choices: [{message: {content: nil}}]}

    stub_request(:post, ChatMessage::GroqClient::API_URL)
      .to_return(status: 200, body: JSON.generate(response_body), headers: {"Content-Type" => "application/json"})

    error = assert_raises(ChatMessage::ParseError) do
      @client.chat("system", "user")
    end

    assert_equal "Empty response from Groq", error.message
  end

  test "chat raises ParseError on invalid JSON body" do
    stub_request(:post, ChatMessage::GroqClient::API_URL)
      .to_return(status: 200, body: "not json", headers: {"Content-Type" => "application/json"})

    error = assert_raises(ChatMessage::ParseError) do
      @client.chat("system", "user")
    end

    assert_match(/Failed to parse Groq response/, error.message)
  end
end
