require "test_helper"

class SetupsControllerTest < ActionDispatch::IntegrationTest
  test "should get show when no users exist" do
    User.destroy_all

    get setup_url
    assert_response :success
  end

  test "should redirect to sessions when users exist" do
    get setup_url
    assert_redirected_to new_sessions_path
  end

  test "should create first user and sign in" do
    User.destroy_all

    assert_difference("User.count") do
      post setup_url, params: {
        user: {
          username: "firstuser",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    user = User.last
    assert user.superuser?
    assert_redirected_to root_path

    # Should create a session cookie
    assert_not_nil parsed_cookies.signed[:session_token]
  end

  test "should not create user with invalid data" do
    User.destroy_all

    assert_no_difference("User.count") do
      post setup_url, params: {
        user: {
          username: "",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "should not create user with mismatched password confirmation" do
    User.destroy_all

    assert_no_difference("User.count") do
      post setup_url, params: {
        user: {
          username: "firstuser",
          password: "password123",
          password_confirmation: "wrongpassword"
        }
      }
    end

    assert_response :unprocessable_content
  end

  test "should redirect create to sessions when users exist" do
    assert_no_difference("User.count") do
      post setup_url, params: {
        user: {
          username: "newuser",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end

    assert_redirected_to new_sessions_path
  end
end
