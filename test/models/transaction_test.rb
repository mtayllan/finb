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
end
