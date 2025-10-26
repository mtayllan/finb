require "test_helper"

class StatementAnalysis::ItemTest < ActiveSupport::TestCase
  test "validates presence of required fields" do
    item = StatementAnalysis::Item.new
    assert_not item.valid?
    assert_includes item.errors[:description], "can't be blank"
    assert_includes item.errors[:date], "can't be blank"
    assert_includes item.errors[:value], "can't be blank"
    assert_includes item.errors[:row_number], "can't be blank"
  end

  test "calculated_value returns same value for non-credit-card account" do
    analysis = StatementAnalysis.create!(
      account: accounts(:bank_one),
      total_rows: 1
    )

    item = analysis.items.create!(
      description: "Test",
      date: Date.current,
      value: -100,
      row_number: 1
    )

    assert_equal(-100, item.calculated_value)
  end

  test "calculated_value inverts sign for credit card account" do
    analysis = StatementAnalysis.create!(
      account: accounts(:credit_one),
      total_rows: 1
    )

    item = analysis.items.create!(
      description: "Test",
      date: Date.current,
      value: 100,
      row_number: 1
    )

    assert_equal(-100, item.calculated_value)
  end

  test "validates date is after account initial_balance_date" do
    account = accounts(:bank_one)
    account.update!(initial_balance_date: Date.new(2024, 1, 1))

    analysis = StatementAnalysis.create!(
      account: account,
      total_rows: 1
    )

    item = analysis.items.new(
      description: "Test",
      date: Date.new(2023, 12, 31),
      value: 100,
      row_number: 1
    )

    assert_not item.valid?
    assert_includes item.errors[:date], "must be after account's initial balance date: 2024-01-01"
  end
end
