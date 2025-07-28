# frozen_string_literal: true

require "test_helper"

class SplitsControllerTest < ActionDispatch::IntegrationTest
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

    @split = create(:split,
      source_transaction: @transaction,
      payer: @user,
      owes_to: @other_user,
      amount_owed: 50.00)
  end

  test "should get index" do
    get splits_url
    assert_response :success
  end

  test "should get index with from_me tab" do
    get splits_url(tab: "from_me")
    assert_response :success
  end

  test "should get index with to_me tab" do
    get splits_url(tab: "to_me")
    assert_response :success
  end

  test "should get index with summary tab" do
    get splits_url(tab: "summary")
    assert_response :success
  end

  test "should show split" do
    get split_url(@split)
    assert_response :success
  end

  test "should get edit" do
    get edit_split_url(@split)
    assert_response :success
  end

  test "should update split" do
    patch split_url(@split), params: {split: {amount_owed: 75.00}}
    assert_redirected_to splits_path
    @split.reload
    assert_equal 75.00, @split.amount_owed
  end

  test "should destroy split" do
    assert_difference("Split.count", -1) do
      delete split_url(@split)
    end
    assert_redirected_to splits_path
  end

  test "should mark split as paid" do
    assert_nil @split.paid_at
    patch mark_as_paid_split_url(@split)
    assert_redirected_to splits_path
    @split.reload
    assert_not_nil @split.paid_at
  end

  private

  def login_as(user)
    get new_sessions_url
    post sessions_url, params: {username: user.username, password: "qwe123"}
  end
end
