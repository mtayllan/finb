require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "presence validations" do
    transaction = build(:transaction, value: nil, date: nil, description: nil)
    assert_not transaction.valid?
    assert_includes transaction.errors[:value], "can't be blank"
    assert_includes transaction.errors[:date], "can't be blank"
    assert_includes transaction.errors[:description], "can't be blank"

    transaction.assign_attributes(value: 100, date: Date.current, description: "test")
    assert transaction.valid?
  end

  test "value must be different than 0" do
    transaction = build(:transaction, value: 0)
    assert_not transaction.valid?

    transaction.value = 10
    assert transaction.valid?
  end
end
