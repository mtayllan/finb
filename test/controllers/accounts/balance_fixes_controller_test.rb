require "test_helper"

class Accounts::BalanceFixesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
    @account = accounts(:bank_one)
    @category = categories(:other)
  end

  test "should get new" do
    get new_account_balance_fix_url(@account)
    assert_response :success
  end

  test "should create balance fix with positive difference" do
    @account.update!(balance: 100)

    assert_difference("Transaction.count") do
      post account_balance_fix_url(@account), params: {
        balance_fix: {correct_balance: 150},
        transaction: {description: "Balance adjustment", category_id: @category.id}
      }
    end

    assert_redirected_to account_path(@account)
    transaction = Transaction.last
    assert_equal 50, transaction.value
  end

  test "should create balance fix with negative difference" do
    @account.update!(balance: 200)

    assert_difference("Transaction.count") do
      post account_balance_fix_url(@account), params: {
        balance_fix: {correct_balance: 50},
        transaction: {description: "Adjustment down", category_id: @category.id}
      }
    end

    transaction = Transaction.last
    assert_equal(-150, transaction.value)
  end

  test "should fail when transaction is invalid" do
    assert_no_difference("Transaction.count") do
      post account_balance_fix_url(@account), params: {
        balance_fix: {correct_balance: 100},
        transaction: {description: "", category_id: @category.id}
      }
    end

    assert_response :unprocessable_content
  end
end
