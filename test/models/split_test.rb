require "test_helper"

class SplitTest < ActiveSupport::TestCase
  test "valid split" do
    user1 = users(:default)
    user2 = create(:user)
    transaction = create(:transaction, account: user1.accounts.first, value: 100.00)

    split = Split.new(
      source_transaction: transaction,
      payer: user1,
      owes_to: user2,
      amount_owed: 25.00
    )

    assert split.valid?
  end

  test "amount_owed must be present" do
    split = build(:split, amount_owed: nil)
    assert_not split.valid?
    assert_includes split.errors[:amount_owed], "can't be blank"
  end

  test "amount_owed must be greater than zero" do
    split = build(:split, amount_owed: 0)
    assert_not split.valid?
    assert_includes split.errors[:amount_owed], "must be greater than 0"
  end

  test "users must be different" do
    user = users(:default)
    split = build(:split, payer: user, owes_to: user)
    assert_not split.valid?
    assert_includes split.errors[:owes_to], "can't be the same as payer"
  end

  test "source_transaction must be unique" do
    transaction = create(:transaction, value: 200.00)
    create(:split, source_transaction: transaction, amount_owed: 50.00)

    duplicate_split = build(:split, source_transaction: transaction, amount_owed: 25.00)
    assert_not duplicate_split.valid?
    assert_includes duplicate_split.errors[:source_transaction_id], "has already been taken"
  end

  test "amount cannot exceed transaction value" do
    transaction = create(:transaction, value: 100.00)
    split = build(:split, source_transaction: transaction, amount_owed: 150.00)
    assert_not split.valid?
    assert_includes split.errors[:amount_owed], "can't exceed transaction value"
  end

  test "owes_to_category must belong to owes_to user" do
    user1 = users(:default)
    user2 = create(:user)
    category_user1 = categories(:food)

    split = build(:split,
      payer: user1,
      owes_to: user2,
      owes_to_category: category_user1,
      amount_owed: 25.00)

    assert_not split.valid?
    assert_includes split.errors[:owes_to_category], "must belong to the person who owes"
  end

  test "paid? returns correct status" do
    unpaid_split = build(:split, amount_owed: 25.00)
    paid_split = build(:split, :paid, amount_owed: 25.00)

    assert_not unpaid_split.paid?
    assert paid_split.paid?
  end

  test "mark_as_paid! sets paid_at" do
    transaction = create(:transaction, value: 100.00)
    split = create(:split, source_transaction: transaction, amount_owed: 25.00)
    assert_nil split.paid_at

    split.mark_as_paid!
    assert_not_nil split.paid_at
  end

  test "mark_as_unpaid! clears paid_at" do
    transaction = create(:transaction, value: 100.00)
    split = create(:split, :paid, source_transaction: transaction, amount_owed: 25.00)
    assert_not_nil split.paid_at

    split.mark_as_unpaid!
    assert_nil split.paid_at
  end
end
