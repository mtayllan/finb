require "test_helper"

class CreditCardsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get credit_cards_url
    assert_response :success
  end

  test "should get show" do
    get credit_card_url(accounts(:credit_one))
    assert_response :success
  end
end
