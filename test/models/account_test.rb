require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "validations" do
    account = Account.new(name: "", color: "", initial_balance: nil, initial_balance_date: nil, kind: nil)
    assert_not account.valid?
    assert_includes account.errors[:name], "can't be blank"
    assert_includes account.errors[:color], "can't be blank"
    assert_includes account.errors[:initial_balance], "can't be blank"
    assert_includes account.errors[:initial_balance_date], "can't be blank"
    assert_includes account.errors[:kind], "can't be blank"

    account.assign_attributes(
      name: "Bank One", color: "#000", initial_balance: 0,
      kind: :checking, initial_balance_date: Date.current
    )
    assert account.valid?
  end

  test "#update_balance" do
    account = create(:account, initial_balance: 30)
    initial_balance = account.initial_balance
    transaction_value = 100
    income_transfer_value = 50
    outcome_transfer_value = 20

    create(:transaction, account: account, value: transaction_value)
    create(:transfer, origin_account: account, value: income_transfer_value)
    create(:transfer, target_account: account, value: outcome_transfer_value)

    expected_balance = initial_balance + transaction_value - income_transfer_value + outcome_transfer_value

    account.update_balance
    account.reload

    assert_equal expected_balance, account.balance
  end

  test ".update_balance" do
    account = create(:account, initial_balance: 30)
    initial_balance = account.initial_balance
    transaction_value = 100
    income_transfer_value = 50
    outcome_transfer_value = 20

    create(:transaction, account: account, value: transaction_value)
    create(:transfer, origin_account: account, value: income_transfer_value)
    create(:transfer, target_account: account, value: outcome_transfer_value)

    expected_balance = initial_balance + transaction_value - income_transfer_value + outcome_transfer_value

    Account.update_balance(account.id)
    account.reload

    assert_equal expected_balance, account.balance
  end
end
