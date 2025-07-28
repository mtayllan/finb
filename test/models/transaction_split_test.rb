require "test_helper"

class TransactionSplitTest < ActiveSupport::TestCase
  test "transaction can have a split" do
    transaction = create(:transaction, value: -200.00)
    split = create(:split, source_transaction: transaction, amount_owed: 100.00)

    assert_includes transaction.splits, split
  end

  test "has_split? returns correct status" do
    transaction_with_split = create(:transaction, value: -200.00)
    transaction_without_split = create(:transaction, value: -200.00)

    create(:split, source_transaction: transaction_with_split, amount_owed: 100.00)

    assert transaction_with_split.has_split?
    assert_not transaction_without_split.has_split?
  end

  test "splittable? returns correct status" do
    # Com a nova lógica, transações negativas são sempre splittable
    transaction_negative = create(:transaction, value: -200.00)
    transaction_positive = create(:transaction, value: 200.00)

    assert transaction_negative.splittable?
    assert_not transaction_positive.splittable?
  end

  test "final_value for payer returns value minus split amount" do
    user = users(:default)
    transaction = create(:transaction, account: user.accounts.first, value: 100.00)
    other_user = create(:user)

    split = create(:split,
      source_transaction: transaction,
      payer: user,
      owes_to: other_user,
      amount_owed: 20.00)

    expected_final_value = transaction.value - split.amount_owed
    assert_equal expected_final_value, transaction.final_value
  end

  test "final_value for non-payer returns full value" do
    user = users(:default)
    other_user = create(:user)
    transaction = create(:transaction, account: user.accounts.first, value: 100.00)

    # Create split where other_user is the payer
    create(:split,
      source_transaction: transaction,
      payer: other_user,
      owes_to: user,
      amount_owed: 20.00)

    # Transaction owner is not the payer, so gets full value
    assert_equal transaction.value, transaction.final_value
  end

  test "final_value without split returns full value" do
    transaction = create(:transaction, value: 100.00)
    assert_equal transaction.value, transaction.final_value
  end
end
