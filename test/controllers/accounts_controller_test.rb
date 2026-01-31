require "test_helper"

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

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
      post accounts_url, params: {account: {name: Faker::Bank.name, initial_balance_date: Date.current.iso8601}}
    end

    account = Account.last
    assert_redirected_to accounts_url(account)
    assert_equal flash[:notice], "Account was successfully created."
  end

  test "should show error on invalid account creation" do
    post accounts_url, params: {account: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should get edit" do
    account = accounts(:bank_one)

    get edit_account_url(account)

    assert_response :success
  end

  test "should update account" do
    account = accounts(:bank_one)

    patch account_url(account), params: {account: {name: Faker::Bank.name, initial_balance: 50}}
    assert_redirected_to accounts_url(account)
    assert_equal flash[:notice], "Account was successfully updated."
  end

  test "should show error on invalid account update" do
    account = accounts(:bank_one)

    patch account_url(account), params: {account: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should destroy account" do
    account = accounts(:bank_one)

    assert_difference("Account.count", -1) do
      delete account_url(account)
    end

    assert_redirected_to accounts_url
    assert_equal flash[:notice], "Account was successfully destroyed."
  end

  test "show checking account report" do
    account = accounts(:bank_one)

    get account_url(account)

    assert_select "turbo-frame#expenses_by_categories"
    assert_select "turbo-frame#income_by_categories"
  end

  test "show savings account report" do
    account = accounts(:savings_one)

    get account_url(account)

    assert_select "turbo-frame#daily_balances"
  end

  test "show investment account report" do
    account = accounts(:investments_one)

    get account_url(account)

    assert_select "turbo-frame#daily_balances"
  end

  test "show credit_card account report" do
    account = accounts(:credit_one)

    get account_url(account)

    assert_select "turbo-frame#expenses_by_categories"
  end

  test "show account transactions filtered by category" do
    # Create fresh account to avoid conflicts with fixture data and parallel tests
    user = users(:default)
    account = create(:account, user: user, initial_balance_date: 1.year.ago)
    category = categories(:food)
    other_category = categories(:other)
    create_list(:transaction, 3, account: account, category: category)
    create_list(:transaction, 2, account: account, category: other_category)

    get account_url(account, params: {category_id: category.id})

    assert_select "tr", 5
  end

  test "show account transactions filtered by month" do
    # Create fresh account to avoid conflicts with fixture data and parallel tests
    user = users(:default)
    account = create(:account, user: user, initial_balance_date: 1.year.ago)
    create_list(:transaction, 3, account: account, date: Date.current)
    create_list(:transaction, 2, account: account, date: 1.month.from_now)

    get account_url(account, params: {month: Date.current.iso8601})

    assert_select "tr", 5
  end
end
