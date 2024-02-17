require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get index with filtered results" do
    get transactions_url, params: { month:  Date.current.strftime("%Y/%m"), category_id: create(:category).id, account_id: create(:account).id }
    assert_response :success
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create expense transaction" do
    account = create(:account)
    assert_difference("Transaction.count") do
      post transactions_url, params: { transaction: {
        date: Date.current, value: 10, description: "test", transaction_type: "expense",
        account_id: account.id, category_id: create(:category).id
      } }
    end

    assert_redirected_to account_url(account)
    assert_equal flash[:notice], "Transaction was successfully created."
    assert_equal Transaction.last.value, -10
  end

  test "should create income transaction" do
    account = create(:account)
    assert_difference("Transaction.count") do
      post transactions_url, params: { transaction: {
        date: Date.current, value: 10, description: "test", transaction_type: "income",
        account_id: account.id, category_id: create(:category).id
      } }
    end

    assert_redirected_to account_url(account)
    assert_equal flash[:notice], "Transaction was successfully created."
    assert_equal Transaction.last.value, 10
  end

  test "should show error on invalid transaction creation" do
    post transactions_url, params: { transaction: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    @transaction = create(:transaction)

    get edit_transaction_url(@transaction)
    assert_response :success
  end

  test "should update transaction" do
    @transaction = create(:transaction)

    patch transaction_url(@transaction), params: { transaction: { name: Faker::Bank.name } }
    assert_redirected_to account_url(@transaction.account)
    assert_equal flash[:notice], "Transaction was successfully updated."
  end

  test "should show error on invalid transaction update" do
    @transaction = create(:transaction)

    patch transaction_url(@transaction), params: { transaction: { date: nil } }

    assert_response :unprocessable_entity
  end

  test "should destroy transaction" do
    @transaction = create(:transaction)
    assert_difference("Transaction.count", -1) do
      delete transaction_url(@transaction)
    end

    assert_redirected_to account_url(@transaction.account)
    assert_equal flash[:notice], "Transaction was successfully destroyed."
  end
end
