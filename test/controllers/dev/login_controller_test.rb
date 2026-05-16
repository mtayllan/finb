require "test_helper"

class Dev::LoginControllerTest < ActionDispatch::IntegrationTest
  test "creates session and redirects to root for valid user" do
    user = users(:default)

    get dev_login_path(id: user.id)

    assert_redirected_to root_path
    assert parsed_cookies.signed[:session_token].present?
  end

  test "returns not found for non-existent user" do
    get dev_login_path(id: 999999)
    assert_response :not_found
  end
end
