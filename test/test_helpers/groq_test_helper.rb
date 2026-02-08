module GroqTestHelper
  def stub_groq_api(transaction_data)
    response_body = {
      choices: [
        {
          message: {
            content: JSON.generate(transaction_data)
          }
        }
      ]
    }

    stub_request(:post, ChatMessage::GroqClient::API_URL)
      .to_return(status: 200, body: JSON.generate(response_body), headers: {"Content-Type" => "application/json"})
  end

  def stub_groq_api_error(status:, body: "Internal Server Error")
    stub_request(:post, ChatMessage::GroqClient::API_URL)
      .to_return(status: status, body: body, headers: {"Content-Type" => "application/json"})
  end

  def stub_groq_api_timeout
    stub_request(:post, ChatMessage::GroqClient::API_URL)
      .to_timeout
  end
end
