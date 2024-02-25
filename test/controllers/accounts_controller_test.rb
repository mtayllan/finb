require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    assert_difference("Account.count") do
      post accounts_url, params: { account: { name: Faker::Bank.name, initial_balance_date: Date.current.iso8601 } }
    end

    assert_redirected_to accounts_url
    assert_equal flash[:notice], "Account was successfully created."
  end

  test "should show error on invalid account creation" do
    post accounts_url, params: { account: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    @account = create(:account)

    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    @account = create(:account)

    patch account_url(@account), params: { account: { name: Faker::Bank.name, initial_balance: 50 } }
    assert_redirected_to accounts_url
    assert_equal flash[:notice], "Account was successfully updated."
  end

  test "should show error on invalid account update" do
    @account = create(:account)

    patch account_url(@account), params: { account: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "should destroy account" do
    @account = create(:account)
    assert_difference("Account.count", -1) do
      delete account_url(@account)
    end

    assert_redirected_to accounts_url
    assert_equal flash[:notice], "Account was successfully destroyed."
  end
end
