require "test_helper"

class SplitTest < ActiveSupport::TestCase
  test "should not allow duplicate splits for same payer transaction" do
    user2 = User.create!(username: "user2", password: "password123")
    account = accounts(:bank_one)
    category = categories(:food)

    payer_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Test transaction",
      value: -100.0,
      date: Date.current
    )

    # Create first split
    Split.create!(
      payer_transaction: payer_transaction,
      borrower: user2,
      amount_borrowed: 10.0
    )

    # Attempt to create second split with same payer transaction
    split2 = Split.new(
      payer_transaction: payer_transaction,
      borrower: user2,
      amount_borrowed: 5.0
    )

    assert_not split2.valid?
    assert_includes split2.errors[:payer_transaction_id], "can only have one split per transaction"
  end

  test "should not allow duplicate splits for same borrower transaction" do
    user2 = User.create!(username: "user3", password: "password123")
    account = accounts(:bank_one)
    category = categories(:food)

    payer_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Payer transaction",
      value: -100.0,
      date: Date.current
    )

    borrower_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Borrower transaction",
      value: 50.0,
      date: Date.current
    )

    another_payer_transaction = Transaction.create!(
      account: account,
      category: category,
      description: "Another payer transaction",
      value: -80.0,
      date: Date.current
    )

    # Create first split
    Split.create!(
      payer_transaction: payer_transaction,
      borrower_transaction: borrower_transaction,
      borrower: user2,
      amount_borrowed: 10.0
    )

    # Attempt to create second split with same borrower transaction
    split2 = Split.new(
      payer_transaction: another_payer_transaction,
      borrower_transaction: borrower_transaction,
      borrower: user2,
      amount_borrowed: 5.0
    )

    assert_not split2.valid?
    assert_includes split2.errors[:borrower_transaction_id], "can only have one split per transaction"
  end

  test "should allow multiple splits with different transactions" do
    user2 = User.create!(username: "user4", password: "password123")
    account = accounts(:bank_one)
    category = categories(:food)

    transaction1 = Transaction.create!(
      account: account,
      category: category,
      description: "Transaction 1",
      value: -100.0,
      date: Date.current
    )

    transaction2 = Transaction.create!(
      account: account,
      category: category,
      description: "Transaction 2",
      value: -80.0,
      date: Date.current
    )

    split1 = Split.create!(
      payer_transaction: transaction1,
      borrower: user2,
      amount_borrowed: 10.0
    )

    split2 = Split.create!(
      payer_transaction: transaction2,
      borrower: user2,
      amount_borrowed: 5.0
    )

    assert split1.valid?
    assert split2.valid?
  end
end
