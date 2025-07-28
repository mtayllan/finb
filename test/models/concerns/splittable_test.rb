# frozen_string_literal: true

require "test_helper"

class SplittableTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:default)
    @user2 = users(:user_two)
  end

  test "includes splittable associations" do
    assert_respond_to @user1, :splits_as_payer
    assert_respond_to @user1, :splits_as_owes_to
    assert_respond_to @user1, :all_splits
  end

  test "splits_for_view returns correct splits for from_me" do
    split = create_split(@user1, @user2)

    splits = @user1.splits_for_view("from_me")
    assert_includes splits, split
  end

  test "splits_for_view returns correct splits for to_me" do
    split = create_split(@user2, @user1)

    splits = @user1.splits_for_view("to_me")
    assert_includes splits, split
  end

  test "splits_for_view returns all splits for summary" do
    split1 = create_split(@user1, @user2)
    split2 = create_split(@user2, @user1)

    splits = @user1.splits_for_view("summary")
    assert_includes splits, split1
    assert_includes splits, split2
  end

  test "has splits_summary method" do
    assert_respond_to @user1, :splits_summary

    summary = @user1.splits_summary
    assert_kind_of Hash, summary
    assert_includes summary, :total_i_owe
    assert_includes summary, :count_i_owe
    assert_includes summary, :total_owed_to_me
    assert_includes summary, :count_owed_to_me
    assert_includes summary, :net_balance
  end

  private

  def create_split(payer, owes_to, amount = 50.0)
    transaction = Transaction.create!(
      account: ensure_account(payer),
      category: ensure_category(payer),
      description: "Test transaction #{SecureRandom.hex(4)}",
      value: -amount,
      date: Date.current
    )

    Split.create!(
      source_transaction: transaction,
      payer: payer,
      owes_to: owes_to,
      amount_owed: amount,
      owes_to_category: ensure_category(owes_to)
    )
  end

  def ensure_account(user)
    user.accounts.first || Account.create!(
      name: "Test Account #{user.username}",
      user: user,
      kind: :checking,
      initial_balance: 0,
      initial_balance_date: Date.current
    )
  end

  def ensure_category(user)
    user.categories.first || Category.create!(
      name: "Test Category #{user.username}",
      user: user,
      icon: "test",
      color: "#000000"
    )
  end
end
