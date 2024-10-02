require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    ENV["CREDENTIAL"] = "valid_username:valid_password"
  end

  teardown do
    ENV["CREDENTIAL"] = ""
  end

  test "should get show" do
    get sessions_url
    assert_response :success
  end

  test "should redirect to root if feature is not enabled" do
    ENV["CREDENTIAL"] = ""
    get sessions_url
    assert_redirected_to root_url
  end

  test "should create session with valid credentials" do
    post sessions_url, params: { username: "valid_username", password: "valid_password" }

    assert_redirected_to root_url
    assert cookies[:auth_token].present?
  end

  test "should render show with error message for invalid credentials" do
    post sessions_url, params: { username: "invalid_username", password: "invalid_password" }

    assert_response :unprocessable_entity
    assert_equal "Invalid username or password.", flash[:alert]
  end

  test "should destroy session" do
    delete sessions_url

    assert_redirected_to sessions_url
    assert_nil cookies[:auth_token]
  end
end
