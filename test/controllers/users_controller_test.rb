require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
    @user = users(:secondary)
  end

  test "should get index as superuser" do
    get users_url
    assert_response :success
  end

  test "should deny access to non-superuser" do
    post sessions_path, params: {username: "sister", password: "asd456"}

    get users_url
    assert_redirected_to root_path
    assert_equal flash[:alert], "Access denied. Superuser privileges required."
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: {user: {username: "newuser", password: "password123", password_confirmation: "password123", superuser: false}}
    end

    assert_redirected_to users_url
    assert_equal flash[:notice], "User created successfully"
  end

  test "should not create user with invalid data" do
    assert_no_difference("User.count") do
      post users_url, params: {user: {username: "", password: "password123"}}
    end

    assert_response :unprocessable_content
  end

  test "should get edit" do
    get edit_user_url(@user)
    assert_response :success
  end

  test "should update user" do
    patch user_url(@user), params: {user: {username: "updated_username"}}
    assert_redirected_to users_url
    assert_equal flash[:notice], "User updated successfully"
    @user.reload
    assert_equal "updated_username", @user.username
  end

  test "should update user password" do
    patch user_url(@user), params: {user: {password: "newpassword123", password_confirmation: "newpassword123"}}
    assert_redirected_to users_url
    @user.reload
    assert @user.authenticate("newpassword123")
  end

  test "should not update user with invalid data" do
    patch user_url(@user), params: {user: {username: ""}}
    assert_response :unprocessable_content
  end

  test "should destroy user" do
    user_to_delete = User.create!(username: "todelete", password: "password123", password_confirmation: "password123")

    assert_difference("User.count", -1) do
      delete user_url(user_to_delete)
    end

    assert_redirected_to users_url
    assert_equal flash[:notice], "User deleted successfully"
  end

  test "should not allow deleting own user account" do
    superuser = users(:default)

    assert_no_difference("User.count") do
      delete user_url(superuser)
    end

    assert_redirected_to users_url
    assert_equal flash[:alert], "Cannot delete your own user account"
  end
end
