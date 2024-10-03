require "test_helper"

class Reports::DailyBalancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should return daily balances report" do
    account = accounts(:bank_one)

    get reports_daily_balance_url(account_id: account.id)

    assert_select "turbo-frame#daily_balances"
    assert_select "turbo-frame [data-controller='daily-balance-chart']"
  end
end
