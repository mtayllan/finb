require "test_helper"

class SplitTest < ActiveSupport::TestCase
  test "should update payer transaction report_value when split is created" do
    user2 = User.create!(username: "user5", password: "password123")
    account = accounts(:bank_one)
    category = categories(:food)

    payer_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Test transaction",
      value: -100.0,
      date: Date.current
    )

    # Initially, report_value should equal the transaction value
    assert_equal(-100.0, payer_transaction.reload.report_value.to_f)

    # Create a split
    Split.create!(
      payer_transaction: payer_transaction,
      borrower: user2,
      amount_borrowed: 30.0
    )

    # After creating split, report_value should be updated: -100 + 30 = -70
    assert_equal(-70.0, payer_transaction.reload.report_value.to_f)
  end

  test "should update payer transaction report_value when split is updated" do
    user2 = User.create!(username: "user6", password: "password123")
    account = accounts(:bank_one)
    category = categories(:food)

    payer_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Test transaction",
      value: -100.0,
      date: Date.current
    )

    # Create a split
    split = Split.create!(
      payer_transaction: payer_transaction,
      borrower: user2,
      amount_borrowed: 30.0
    )

    # Initial report_value: -100 + 30 = -70
    assert_equal(-70.0, payer_transaction.reload.report_value.to_f)

    # Update the split amount
    split.update!(amount_borrowed: 50.0)

    # Updated report_value: -100 + 50 = -50
    assert_equal(-50.0, payer_transaction.reload.report_value.to_f)
  end

  test "should update payer transaction report_value when split is destroyed" do
    user2 = User.create!(username: "user7", password: "password123")
    account = accounts(:bank_one)
    category = categories(:food)

    payer_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Test transaction",
      value: -100.0,
      date: Date.current
    )

    # Create a split
    split = Split.create!(
      payer_transaction: payer_transaction,
      borrower: user2,
      amount_borrowed: 30.0
    )

    # With split: -100 + 30 = -70
    assert_equal(-70.0, payer_transaction.reload.report_value.to_f)

    # Destroy the split
    split.destroy!

    # After destroying split, report_value should return to original value: -100 + 0 = -100
    assert_equal(-100.0, payer_transaction.reload.report_value.to_f)
  end
end
