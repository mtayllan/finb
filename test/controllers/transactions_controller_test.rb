require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get transactions_url
    assert_response :success
  end

  test "should get index with filtered results" do
    get transactions_url, params: {category_id: create(:category).id, account_id: create(:account).id}
    assert_response :success
  end

  test "index filters by category and account" do
    user = users(:default)
    account = create(:account, user:)
    other_account = create(:account, user:)
    matching = create(:transaction, account:, category: categories(:food), value: -5)
    create(:transaction, account: other_account, category: categories(:other), value: -5)

    get transactions_url, params: {category_id: categories(:food).id, account_id: account.id}

    assert_response :success
    assert_select "tr#transaction_#{matching.id}"
    assert_select "tr[id^=?]", "transaction_", 1
  end

  test "index filters by date range" do
    user = users(:default)
    account = create(:account, user:, initial_balance_date: 1.year.ago)
    in_range = create(:transaction, account:, category: categories(:food), date: Date.current, value: -5)
    out_of_range = create(:transaction, account:, category: categories(:food), date: 2.months.ago.to_date, value: -5)

    get transactions_url, params: {start_date: 1.month.ago.to_date.to_s, end_date: Date.current.to_s}

    assert_response :success
    assert_select "tr#transaction_#{in_range.id}"
    assert_select "tr#transaction_#{out_of_range.id}", false
  end

  test "index filters by tag" do
    user = users(:default)
    account = create(:account, user:)
    tag = tags(:tropicalrb)
    tagged = create(:transaction, account:, category: categories(:food), value: -5)
    tagged.tags << tag
    create(:transaction, account:, category: categories(:food), value: -5)

    get transactions_url, params: {tag_ids: [tag.id]}

    assert_response :success
    assert_select "tr#transaction_#{tagged.id}"
    assert_select "tr[id^=?]", "transaction_", 1
  end

  test "index paginates 20 per page" do
    user = users(:default)
    account = create(:account, user:)
    Transaction.delete_all
    create_list(:transaction, 51, account:, category: categories(:food), value: -5, date: Date.current)

    get transactions_url
    assert_response :success
    assert_select "tr[id^=?]", "transaction_", 20

    # page 0 -> offset 0, page -1 -> offset 20, page -2 -> offset 40 (11 remaining)
    get transactions_url, params: {page: -2}
    assert_response :success
    assert_select "tr[id^=?]", "transaction_", 11
  end

  test "index defaults anchored at today, skipping future transactions" do
    user = users(:default)
    account = create(:account, user:, initial_balance_date: 2.years.ago)
    Transaction.delete_all
    future = create(:transaction, account:, category: categories(:food), value: -5, date: 1.month.from_now.to_date)
    today_tx = create(:transaction, account:, category: categories(:food), value: -5, date: Date.current)

    get transactions_url
    assert_response :success
    assert_select "tr#transaction_#{today_tx.id}"
    assert_select "tr#transaction_#{future.id}", false

    # Future transactions live on positive pages (Previous).
    get transactions_url, params: {page: 1}
    assert_response :success
    assert_select "tr#transaction_#{future.id}"
    assert_select "tr#transaction_#{today_tx.id}", false
  end

  test "should get new" do
    get new_transaction_url
    assert_response :success
  end

  test "should create expense transaction" do
    account = accounts(:bank_one)
    category = categories(:food)
    assert_difference("Transaction.count") do
      post transactions_url, params: {transaction: {
        date: Date.current, value: 10, description: "test", transaction_type: "expense",
        account_id: account.id, category_id: category.id
      }}
    end

    assert_redirected_to account_url(account)
    assert_equal flash[:notice], "Transaction was successfully created."
    assert_equal Transaction.last.value, -10
  end

  test "should create income transaction" do
    account = accounts(:bank_one)
    category = categories(:salary)
    assert_difference("Transaction.count") do
      post transactions_url, params: {transaction: {
        date: Date.current, value: 10, description: "test", transaction_type: "income",
        account_id: account.id, category_id: category.id
      }}
    end

    assert_redirected_to account_url(account)
    assert_equal flash[:notice], "Transaction was successfully created."
    assert_equal Transaction.last.value, 10
  end

  test "should show error on invalid transaction creation" do
    post transactions_url, params: {transaction: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should get edit" do
    @transaction = transactions(:income1)

    get edit_transaction_url(@transaction)
    assert_response :success
  end

  test "should update transaction" do
    @transaction = transactions(:income1)

    patch transaction_url(@transaction), params: {transaction: {description: Faker::Bank.name}}
    assert_redirected_to account_url(@transaction.account)
    assert_equal flash[:notice], "Transaction was successfully updated."
  end

  test "should show error on invalid transaction update" do
    @transaction = transactions(:income1)

    patch transaction_url(@transaction), params: {transaction: {date: nil}}

    assert_response :unprocessable_content
  end

  test "should destroy transaction" do
    @transaction = transactions(:income1)
    assert_difference("Transaction.count", -1) do
      delete transaction_url(@transaction)
    end

    assert_redirected_to account_url(@transaction.account)
    assert_equal flash[:notice], "Transaction was successfully destroyed."
  end

  test "should recalculate balance of both accounts on account change" do
    user = users(:default)
    old_account = create(:account, initial_balance: 90, balance: 100, user:)
    new_account = create(:account, initial_balance: 150, user:)
    transaction = create(:transaction, account: old_account, value: 10, category: categories(:other))

    patch transaction_url(transaction), params: {transaction: {account_id: new_account.id}}

    assert_equal new_account.reload.balance, 160
    assert_equal old_account.reload.balance, 90
  end
end
