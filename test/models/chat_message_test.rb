require "test_helper"

class ChatMessageTest < ActiveSupport::TestCase
  setup do
    @user = users(:default)
    @account = accounts(:bank_one)
    @credit_card = accounts(:credit_one)
    @category = categories(:food)
  end

  test "process creates transaction and stores response" do
    stub_groq_api(
      value: -5.0,
      date: Date.current.to_s,
      description: "Bread at bakery",
      account_id: @account.id,
      category_id: @category.id
    )

    chat_message = ChatMessage.create!(user: @user, message: "bought bread at bakery today 5 dollars")
    transaction = chat_message.process

    assert_equal(-5.0, transaction.value)
    assert_equal Date.current, transaction.date
    assert_equal "Bread at bakery", transaction.description
    assert_equal @account.id, transaction.account_id
    assert_equal @category.id, transaction.category_id
    assert_nil transaction.credit_card_statement

    chat_message.reload
    assert_not_nil chat_message.response
    assert_equal transaction, chat_message.created_transaction
  end

  test "process sets credit card statement for credit card accounts" do
    stub_groq_api(
      value: -100.0,
      date: Date.current.to_s,
      description: "Online purchase",
      account_id: @credit_card.id,
      category_id: @category.id
    )

    chat_message = ChatMessage.create!(user: @user, message: "bought something online 100 dollars")
    transaction = chat_message.process

    assert_equal @credit_card.id, transaction.account_id
    assert_not_nil transaction.credit_card_statement
    assert_equal Date.current.beginning_of_month, transaction.credit_card_statement.month
  end

  test "process returns nil and stores error response on parse failure" do
    original_key = ENV["GROQ_API_KEY"]
    ENV["GROQ_API_KEY"] = nil

    chat_message = ChatMessage.create!(user: @user, message: "test message")

    assert_nil chat_message.process
    assert_match(/GROQ_API_KEY not configured/, chat_message.response)
  ensure
    ENV["GROQ_API_KEY"] = original_key
  end

  test "process returns nil and stores error response on invalid transaction" do
    stub_groq_api(
      value: 0,
      date: Date.current.to_s,
      description: "Invalid",
      account_id: @account.id,
      category_id: @category.id
    )

    chat_message = ChatMessage.create!(user: @user, message: "test")

    assert_nil chat_message.process
    assert_match(/Error creating transaction/, chat_message.response)
  end
end
