require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get new_sessions_url
    assert_response :success
  end

  test "should redirect to setup when no users exist" do
    User.destroy_all

    get new_sessions_url
    assert_redirected_to setup_path
  end

  test "should create session with valid credentials" do
    user = users(:default)

    post sessions_url, params: {username: user.username, password: "qwe123"}

    assert_redirected_to root_url
    assert parsed_cookies.signed[:session_token]
    assert_equal "Signed in successfully", flash[:notice]
  end

  test "should render show with error message for invalid credentials" do
    post sessions_url, params: {username: "invalid_username", password: "invalid_password"}

    assert_response :unprocessable_content
    assert_equal "Invalid credentials", flash[:alert]
  end

  test "should destroy session" do
    sign_in_default_user

    delete sessions_url

    assert_redirected_to new_sessions_url
    assert_nil parsed_cookies.signed[:session_token]
  end
end
