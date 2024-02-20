require "test_helper"

class Account::BalanceTest < ActiveSupport::TestCase
  test "should have a unique date within the scope of an account" do
    balance = create(:account_balance)
    duplicate_balance = balance.dup
    duplicate_balance.save
    assert_not duplicate_balance.valid?
  end
end
