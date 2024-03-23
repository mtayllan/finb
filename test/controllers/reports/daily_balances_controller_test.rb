require "test_helper"

class Reports::DailyBalancesControllerTest < ActionDispatch::IntegrationTest
  test "should return daily balances report" do
    account = create(:account)

    get reports_daily_balance_url(account_id: account.id)

    assert_select "turbo-frame#daily_balances"
    assert_select "turbo-frame [data-controller='daily-balance-chart']"
  end
end
