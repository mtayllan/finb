require "test_helper"

class ReportsControllerTest < ActionDispatch::IntegrationTest
  include SessionTestHelper

  setup do
    sign_in_default_user
    @user = users(:default)

    @category_income = categories(:salary)
    @category_expense = categories(:food)
    @account_one = accounts(:bank_one)
    @account_two = accounts(:savings_one)

    # Create test transactions
    @income_transaction = Transaction.create!(
      description: "Test Income",
      value: 1000,
      category: @category_income,
      account: @account_one,
      date: Date.current
    )

    @expense_transaction = Transaction.create!(
      description: "Test Expense",
      value: -500,
      category: @category_expense,
      account: @account_two,
      date: Date.current
    )
  end

  test "should get show" do
    get reports_url
    assert_response :success
    assert_select "h1", "Reports"
  end

  test "should display totals" do
    get reports_url

    assert_select ".stat-value", text: "$1,500.00"  # Income (1000 + 500 from fixture)
    assert_select ".stat-value", text: "$500.00"    # Expenses
    assert_select ".stat-value", text: "$1,000.00"  # Net Total
  end

  test "should filter by category" do
    get reports_url, params: {category_id: @category_income.id}

    assert_response :success
    assert_select ".stat-value", text: "$1,500.00"  # Income (both transactions are salary category)
    assert_select ".stat-value", text: "$0.00"      # Expenses
  end

  test "should filter by account" do
    get reports_url, params: {account_id: @account_one.id}

    assert_response :success
    assert_select ".stat-value", text: "$1,500.00"  # Income from account_one (1000 + 500 from fixture)
    assert_select ".stat-value", text: "$0.00"      # No expenses in account_one
  end

  test "should filter by date range" do
    # Create a transaction with date in previous month
    old_date = 1.month.ago
    if old_date >= @account_one.initial_balance_date
      Transaction.create!(
        description: "Old transaction",
        value: -200,
        category: @category_expense,
        account: @account_one,
        date: old_date
      )
    end

    get reports_url, params: {
      start_date: Date.current.beginning_of_month,
      end_date: Date.current.end_of_month
    }

    assert_response :success
    assert_select ".stat-value", text: "$1,500.00"  # Current month income (1000 + 500 from fixture)
  end

  test "should show category breakdown" do
    get reports_url

    assert_response :success
    assert_select "h3", text: "By Category"
    assert_select "td", text: @category_income.name
    assert_select "td", text: @category_expense.name
  end

  test "should show account breakdown" do
    get reports_url

    assert_response :success
    assert_select "h3", text: "By Account"
    assert_select "td", text: @account_one.name
    assert_select "td", text: @account_two.name
  end

  test "should handle quick filter options" do
    get reports_url, params: {quick_filter: "today"}
    assert_response :success

    get reports_url, params: {quick_filter: "this_week"}
    assert_response :success

    get reports_url, params: {quick_filter: "this_month"}
    assert_response :success
  end

  test "should handle granularity options" do
    get reports_url, params: {granularity: "day"}
    assert_response :success
    assert_select "h3", text: "Transaction Totals by Day"

    get reports_url, params: {granularity: "week"}
    assert_response :success
    assert_select "h3", text: "Transaction Totals by Week"

    get reports_url, params: {granularity: "month"}
    assert_response :success
    assert_select "h3", text: "Transaction Totals by Month"
  end

  test "should handle combined filters" do
    get reports_url, params: {
      category_id: @category_income.id,
      account_id: @account_one.id,
      granularity: "day",
      start_date: Date.current.beginning_of_month,
      end_date: Date.current.end_of_month
    }

    assert_response :success
    assert_select ".stat-value", text: "$1,500.00"  # Only income (1000 + 500 from fixture)
    assert_select ".stat-value", text: "$0.00"      # No expenses
  end

  test "should handle invalid date gracefully" do
    get reports_url, params: {start_date: "invalid", end_date: "invalid"}

    assert_response :success
    # Should still render the page with default dates
    assert_select "h1", "Reports"
  end

  test "should display quick filter select" do
    get reports_url

    assert_response :success
    assert_select "select[name='quick_filter']" do
      assert_select "option", text: "Today"
      assert_select "option", text: "This Week"
      assert_select "option", text: "This Month"
      assert_select "option", text: "Last Month"
    end
  end

  test "should display category and account filters" do
    get reports_url

    assert_response :success
    assert_select "label", text: "Category"
    assert_select "label", text: "Account"
    assert_select "label", text: "Start date"
    assert_select "label", text: "End date"
    assert_select "label", text: "Granularity"
  end

  test "should display clear filters link" do
    get reports_url

    assert_response :success
    assert_select "a", text: "Clear Filters"
  end
end
