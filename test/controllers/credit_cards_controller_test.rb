require "test_helper"

class CreditCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get credit_cards_url
    assert_response :success
  end

  test "should get new" do
    get new_credit_card_url
    assert_response :success
  end

  test "should create credit_card" do
    assert_difference("CreditCard.count") do
      post credit_cards_url, params: { credit_card: { name: Faker::Bank.name, limit: 1000, closing_day: 10, due_day: 17, color: "#fff" } }
    end

    credit_card = CreditCard.last
    assert_redirected_to credit_cards_url(credit_card)
    assert_equal flash[:notice], "Credit Card was successfully created."
  end

  test "should show error on invalid credit_card creation" do
    post credit_cards_url, params: { credit_card: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "should get edit" do
    credit_card = credit_cards(:one)
    get edit_credit_card_url(credit_card)
    assert_response :success
  end

  test "should update credit_card" do
    credit_card = credit_cards(:one)

    patch credit_card_url(credit_card), params: { credit_card: { name: Faker::Bank.name, limit: 2000 } }

    assert_redirected_to credit_cards_url(credit_card)
    assert_equal flash[:notice], "Credit Card was successfully updated."
  end

  test "should show error on invalid credit_card update" do
    credit_card = credit_cards(:one)

    patch credit_card_url(credit_card), params: { credit_card: { name: "" } }

    assert_response :unprocessable_entity
  end

  test "should destroy credit_card" do
    credit_card = credit_cards(:one)

    assert_difference("CreditCard.count", -1) do
      delete credit_card_url(credit_card)
    end

    assert_redirected_to credit_cards_url
    assert_equal flash[:notice], "Credit Card was successfully destroyed."
  end
end
