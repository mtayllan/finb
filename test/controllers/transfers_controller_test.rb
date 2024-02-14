require "test_helper"

class TransfersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transfers_url
    assert_response :success
  end

  test "should get new" do
    get new_transfer_url
    assert_response :success
  end

  test "should create transfer" do
    assert_difference("Transfer.count") do
      post transfers_url, params: { transfer: {
        date: Date.current, value: 10, origin_account_id: create(:account).id, target_account_id: create(:account).id
      } }
    end

    assert_redirected_to transfers_url
    assert_equal flash[:notice], "Transfer was successfully created."
  end

  test "should show error on invalid transfer creation" do
    post transfers_url, params: { transfer: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    @transfer = create(:transfer)

    get edit_transfer_url(@transfer)
    assert_response :success
  end

  test "should update transfer" do
    @transfer = create(:transfer)

    patch transfer_url(@transfer), params: { transfer: { name: Faker::Bank.name, initial_balance: 50 } }
    assert_redirected_to transfers_url
    assert_equal flash[:notice], "Transfer was successfully updated."
  end

  test "should show error on invalid transfer update" do
    @transfer = create(:transfer)

    patch transfer_url(@transfer), params: { transfer: { date: nil } }

    assert_response :unprocessable_entity
  end

  test "should destroy transfer" do
    @transfer = create(:transfer)
    assert_difference("Transfer.count", -1) do
      delete transfer_url(@transfer)
    end

    assert_redirected_to transfers_url
    assert_equal flash[:notice], "Transfer was successfully destroyed."
  end
end
