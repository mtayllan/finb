require "test_helper"

class Account::BalanceTest < ActiveSupport::TestCase
  test "should have a unique date within the scope of an account" do
    account = accounts(:bank_one)
    balance = Account::Balance.create(date: Date.current, account:, balance: 100)
    duplicate_balance = balance.dup
    duplicate_balance.save
    assert_not duplicate_balance.valid?
  end
end
