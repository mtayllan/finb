require "test_helper"

class TransfersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_transfer_url
    assert_response :success
  end

  test "should create transfer" do
    user = users(:default)
    origin_account = create(:account, user: user)
    target_account = create(:account, user: user)
    assert_difference("Transfer.count") do
      post transfers_url, params: {transfer: {
        date: Date.current, value: 10, origin_account_id: origin_account.id, target_account_id: target_account.id
      }}
    end

    assert_redirected_to transfers_url
    assert_equal flash[:notice], "Transfer was successfully created."
  end

  test "should show error on invalid transfer creation" do
    post transfers_url, params: {transfer: {name: ""}}

    assert_response :unprocessable_content
  end

  test "should get edit" do
    @transfer = transfers(:one)

    get edit_transfer_url(@transfer)
    assert_response :success
  end

  test "should update transfer" do
    @transfer = transfers(:one)

    patch transfer_url(@transfer), params: {transfer: {description: Faker::Bank.name}}
    assert_redirected_to transfers_url
    assert_equal flash[:notice], "Transfer was successfully updated."
  end

  test "should show error on invalid transfer update" do
    @transfer = transfers(:one)

    patch transfer_url(@transfer), params: {transfer: {date: nil}}

    assert_response :unprocessable_content
  end

  test "should destroy transfer" do
    @transfer = transfers(:one)
    assert_difference("Transfer.count", -1) do
      delete transfer_url(@transfer)
    end

    assert_redirected_to transfers_url
    assert_equal flash[:notice], "Transfer was successfully destroyed."
  end
end
