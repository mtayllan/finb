require "test_helper"

class Reports::ExpensesByCategoriesControllerTest < ActionDispatch::IntegrationTest
  test "should return expenses by cateries report" do
    account = create(:account, kind: :credit_card)
    month = Date.current.beginning_of_month.iso8601

    get reports_expenses_by_category_url(account_id: account.id, month: month)

    assert_select "turbo-frame#expenses_by_categories"
    assert_select "turbo-frame [data-controller='categories-pie-chart']"
  end
end
