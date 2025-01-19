require "test_helper"

class CreditCard::TransactionTest < ActiveSupport::TestCase
  def setup
    @transaction = credit_card_transactions(:one)
  end

  test "should be valid" do
    assert @transaction.valid?
  end

  test "value should be present" do
    @transaction.value = nil
    assert_not @transaction.valid?
  end

  test "total_installments should be present" do
    @transaction.total_installments = nil
    assert_not @transaction.valid?
  end

  test "description should be present" do
    @transaction.description = nil
    assert_not @transaction.valid?
  end

  test "date should be present" do
    @transaction.date = nil
    assert_not @transaction.valid?
  end
end
