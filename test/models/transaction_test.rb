require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "presence validations" do
    transaction = Transaction.new(value: nil, date: nil, description: nil, category: categories(:food), account: accounts(:bank_one))
    assert_not transaction.valid?
    assert_includes transaction.errors[:value], "can't be blank"
    assert_includes transaction.errors[:date], "can't be blank"
    assert_includes transaction.errors[:description], "can't be blank"

    transaction.assign_attributes(value: 100, date: Date.current, description: "test")
    assert transaction.valid?
  end

  test "value must be different than 0" do
    transaction = Transaction.new(value: 0)
    transaction.validate
    assert_includes transaction.errors[:value], "must be other than 0"

    transaction.value = 10
    transaction.validate
    assert_empty transaction.errors[:value]
  end

  test "report_value should be 0 when exclude_from_reports is true" do
    transaction = Transaction.create!(
      account: accounts(:bank_one),
      category: categories(:food),
      description: "Test transaction",
      value: -100.0,
      date: Date.current,
      exclude_from_reports: true
    )

    assert_equal 0, transaction.report_value.to_f
  end

  test "report_value should be calculated normally when exclude_from_reports is false" do
    transaction = Transaction.create!(
      account: accounts(:bank_one),
      category: categories(:food),
      description: "Test transaction",
      value: -100.0,
      date: Date.current,
      exclude_from_reports: false
    )

    assert_equal(-100.0, transaction.report_value.to_f)
  end

  test "report_value should update to 0 when exclude_from_reports is set to true" do
    transaction = Transaction.create!(
      account: accounts(:bank_one),
      category: categories(:food),
      description: "Test transaction",
      value: -100.0,
      date: Date.current,
      exclude_from_reports: false
    )

    assert_equal(-100.0, transaction.reload.report_value.to_f)

    transaction.update!(exclude_from_reports: true)

    assert_equal 0, transaction.reload.report_value.to_f
  end

  test "report_value should be 0 when exclude_from_reports is true even with splits" do
    user2 = User.create!(username: "user_test", password: "password123")

    transaction = Transaction.create!(
      account: accounts(:bank_one),
      category: categories(:food),
      description: "Test transaction",
      value: -100.0,
      date: Date.current,
      exclude_from_reports: true
    )

    Split.create!(
      payer_transaction: transaction,
      borrower: user2,
      amount_borrowed: 30.0
    )

    # Even with a split, excluded transactions should have report_value = 0
    assert_equal 0, transaction.reload.report_value.to_f
  end

  test "report_value should equal value for income transactions" do
    transaction = Transaction.create!(
      account: accounts(:bank_one),
      category: categories(:salary),
      description: "Test income",
      value: 1000.0,
      date: Date.current,
      exclude_from_reports: false
    )

    assert_equal 1000.0, transaction.report_value.to_f
  end
end
