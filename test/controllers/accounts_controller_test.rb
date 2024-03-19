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

  test "show checking account report" do
    account = create(:account, kind: :checking)

    get account_url(account)

    assert_select "turbo-frame#expenses_by_categories"
    assert_select "turbo-frame#income_by_categories"
  end

  test "show savings account report" do
    account = create(:account, kind: :savings)

    get account_url(account)

    assert_select "turbo-frame#daily_balances"
  end

  test "show investment account report" do
    account = create(:account, kind: :investment)

    get account_url(account)

    assert_select "turbo-frame#daily_balances"
  end

  test "show credit_card account report" do
    account = create(:account, kind: :credit_card)

    get account_url(account)

    assert_select "turbo-frame#expenses_by_categories"
  end

  test "show account transactions filtered by category" do
    account = create(:account)
    category = create(:category)
    other_category = create(:category)
    create_list(:transaction, 3, account: account, category:)
    create_list(:transaction, 2, account: account, category: other_category)

    get account_url(account, params: { category_id: category.id })

    assert_select "tr", 4
  end

  test "show account transactions filtered by month" do
    account = create(:account, initial_balance_date: 3.months.ago)
    create_list(:transaction, 3, account: account, date: 1.month.ago)
    create_list(:transaction, 2, account: account, date: 2.months.ago)

    get account_url(account, params: { month: 1.month.ago.iso8601 })

    assert_select "tr", 4
  end
end
