require "test_helper"

class CreditCard::TransactionInstallmentTest < ActiveSupport::TestCase
  def setup
    @transaction_installment = credit_card_transaction_installments(:one)
  end

  test "should be valid" do
    assert @transaction_installment.valid?
  end

  test "value should be present" do
    @transaction_installment.value = nil
    assert_not @transaction_installment.valid?
  end

  test "number should be present" do
    @transaction_installment.number = nil
    assert_not @transaction_installment.valid?
  end

  test "should belong to original_transaction" do
    assert_not_nil @transaction_installment.original_transaction
  end

  test "should belong to statement" do
    assert_not_nil @transaction_installment.statement
  end
end
