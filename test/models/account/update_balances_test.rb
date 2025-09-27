require "test_helper"

class Account::UpdateBalancesTest < ActiveSupport::TestCase
  test "updates balances from initial balance date when no start_date provided" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    # Create transactions on different dates
    create(:transaction, account: account, value: 50, date: base_date + 1.day)
    create(:transaction, account: account, value: -30, date: base_date + 2.days)
    create(:transaction, account: account, value: 20, date: base_date + 4.days)

    # Create transfers
    other_account = create(:account, user: account.user, initial_balance_date: base_date)
    create(:transfer, origin_account: account, target_account: other_account, value: 25, date: base_date + 3.days)
    create(:transfer, origin_account: other_account, target_account: account, value: 15, date: base_date + 5.days)

    Account::UpdateBalances.call(account)

    balances = account.balances.order(:date)

    # Should have balances for dates where balance changed
    assert_equal 5, balances.count

    # Check specific balance calculations
    assert_equal 150, balances.find_by(date: base_date + 1.day).balance  # 100 + 50
    assert_equal 120, balances.find_by(date: base_date + 2.days).balance  # 150 - 30
    assert_equal 95, balances.find_by(date: base_date + 3.days).balance   # 120 - 25
    assert_equal 115, balances.find_by(date: base_date + 4.days).balance  # 95 + 20
    assert_equal 130, balances.find_by(date: base_date + 5.days).balance  # 115 + 15
  end

  test "updates balances from start_date when provided" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    # Create transactions before and after start_date
    create(:transaction, account: account, value: 50, date: base_date + 1.day)
    create(:transaction, account: account, value: -30, date: base_date + 2.days)
    create(:transaction, account: account, value: 20, date: base_date + 4.days)
    create(:transaction, account: account, value: 10, date: base_date + 6.days)

    # First, create all balances
    Account::UpdateBalances.call(account)
    initial_balance_count = account.balances.count

    # Now update only from a specific start_date
    start_date = base_date + 4.days
    Account::UpdateBalances.call(account, start_date: start_date)

    balances = account.balances.order(:date)

    # Should still have all balances, but only updated from start_date
    assert_equal initial_balance_count, balances.count

    # Balances before start_date should remain unchanged
    assert_equal 150, balances.find_by(date: base_date + 1.day).balance  # 100 + 50
    assert_equal 120, balances.find_by(date: base_date + 2.days).balance  # 150 - 30

    # Balances from start_date should be recalculated
    assert_equal 140, balances.find_by(date: base_date + 4.days).balance  # 120 + 20
    assert_equal 150, balances.find_by(date: base_date + 6.days).balance  # 140 + 10
  end

  test "handles case where start_date equals initial_balance_date" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)
    create(:transaction, account: account, value: 50, date: base_date + 1.day)

    # Should behave same as no start_date when start_date equals initial_balance_date
    Account::UpdateBalances.call(account, start_date: account.initial_balance_date)

    balances = account.balances.order(:date)
    assert_equal 1, balances.count
    assert_equal 150, balances.first.balance
  end

  test "calculates previous balance from existing balance records when start_date provided" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    # Create some transactions and build initial balances
    create(:transaction, account: account, value: 50, date: base_date + 1.day)
    create(:transaction, account: account, value: -30, date: base_date + 2.days)
    Account::UpdateBalances.call(account)

    # Add new transaction and update from that date
    create(:transaction, account: account, value: 25, date: base_date + 3.days)
    Account::UpdateBalances.call(account, start_date: base_date + 3.days)

    balances = account.balances.order(:date)

    # Should have balance for the new transaction date
    new_balance = balances.find_by(date: base_date + 3.days)
    assert_not_nil new_balance
    assert_equal 145, new_balance.balance  # Previous balance (120) + new transaction (25)
  end

  test "removes obsolete balance records in date range" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    # Create transactions and balances
    create(:transaction, account: account, value: 50, date: base_date + 1.day)
    create(:transaction, account: account, value: -30, date: base_date + 2.days)
    Account::UpdateBalances.call(account)

    initial_balance_count = account.balances.count

    # Remove a transaction and update balances
    account.transactions.where(date: base_date + 2.days).destroy_all
    Account::UpdateBalances.call(account, start_date: base_date + 2.days)

    # Should have one less balance record
    assert_equal initial_balance_count - 1, account.balances.count

    # The balance for day 2 should be removed
    assert_nil account.balances.find_by(date: base_date + 2.days)
  end

  test "handles account with no transactions or transfers" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    Account::UpdateBalances.call(account)

    # Should have no balance records since balance never changes
    assert_equal 0, account.balances.count
  end

  test "only deletes balances from start_date forward" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    # Create transactions across multiple dates
    create(:transaction, account: account, value: 50, date: base_date + 1.day)
    create(:transaction, account: account, value: -30, date: base_date + 2.days)
    create(:transaction, account: account, value: 20, date: base_date + 4.days)
    Account::UpdateBalances.call(account)

    # Manually create a balance that shouldn't be there
    Account::Balance.create!(account: account, date: base_date + 3.days, balance: 999)

    # Update balances from day 3 forward
    Account::UpdateBalances.call(account, start_date: base_date + 3.days)

    # Balances before start_date should remain
    assert_not_nil account.balances.find_by(date: base_date + 1.day)
    assert_not_nil account.balances.find_by(date: base_date + 2.days)

    # The manually created balance should be removed and replaced with correct one
    balance_day_3 = account.balances.find_by(date: base_date + 3.days)
    assert_nil balance_day_3  # No transaction on this date, so no balance record

    # Balance for day 4 should be correct
    assert_equal 140, account.balances.find_by(date: base_date + 4.days).balance
  end

  test "finds previous balance correctly when there are gaps in balance records" do
    base_date = Date.current - 10.days
    account = create(:account, initial_balance: 100, initial_balance_date: base_date)

    # Create transactions with gaps - day 1 and day 5, but nothing on days 2, 3, 4
    create(:transaction, account: account, value: 50, date: base_date + 1.day)
    create(:transaction, account: account, value: 30, date: base_date + 5.days)
    Account::UpdateBalances.call(account)

    # Now add a transaction on day 6 and update from day 6
    create(:transaction, account: account, value: 20, date: base_date + 6.days)
    Account::UpdateBalances.call(account, start_date: base_date + 6.days)

    balances = account.balances.order(:date)

    # Should have 3 balance records: day 1, day 5, and day 6
    assert_equal 3, balances.count
    assert_equal 150, balances.find_by(date: base_date + 1.day).balance   # 100 + 50
    assert_equal 180, balances.find_by(date: base_date + 5.days).balance  # 150 + 30
    assert_equal 200, balances.find_by(date: base_date + 6.days).balance  # 180 + 20

    # The previous balance for day 6 calculation should have been found from day 5
    # even though there were no balance records for days 2, 3, 4
  end
end
