# frozen_string_literal: true

require "test_helper"

class Transactions::SplitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:default)
    @other_user = users(:user_two)
    login_as @user

    @transaction = @user.accounts.first.transactions.create!(
      value: -100.00,
      description: "Test transaction",
      date: Date.current,
      category: @user.categories.first
    )
  end

  test "should get new" do
    get new_transaction_split_url(@transaction)
    assert_response :success
  end

  test "should create split" do
    assert_difference("Split.count", 1) do
      post transaction_split_url(@transaction), params: {
        split: {
          owes_to_id: @other_user.id,
          amount_owed: 50.00
        }
      }
    end
    assert_redirected_to transactions_path
  end

  test "should not create split with invalid data" do
    assert_no_difference("Split.count") do
      post transaction_split_url(@transaction), params: {
        split: {
          owes_to_id: nil,
          amount_owed: nil
        }
      }
    end
    assert_response :unprocessable_entity
  end

  test "should show split" do
    create(:split,
      source_transaction: @transaction,
      payer: @user,
      owes_to: @other_user,
      amount_owed: 50.00)

    get transaction_split_url(@transaction)
    assert_response :success
  end

  test "should get edit" do
    create(:split,
      source_transaction: @transaction,
      payer: @user,
      owes_to: @other_user,
      amount_owed: 50.00)

    get edit_transaction_split_url(@transaction)
    assert_response :success
  end

  test "should update split" do
    split = create(:split,
      source_transaction: @transaction,
      payer: @user,
      owes_to: @other_user,
      amount_owed: 50.00)

    patch transaction_split_url(@transaction), params: {
      split: {amount_owed: 75.00}
    }
    assert_redirected_to transactions_path
    split.reload
    assert_equal 75.00, split.amount_owed
  end

  test "should destroy split" do
    create(:split,
      source_transaction: @transaction,
      payer: @user,
      owes_to: @other_user,
      amount_owed: 50.00)

    assert_difference("Split.count", -1) do
      delete transaction_split_url(@transaction)
    end
    assert_redirected_to transactions_path
  end

  private

  def login_as(user)
    get new_sessions_url
    post sessions_url, params: {username: user.username, password: "qwe123"}
  end
end
