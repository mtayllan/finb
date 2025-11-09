require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "superuser? returns true for superuser" do
    user = users(:default)
    assert user.superuser?
  end

  test "superuser? returns false for regular user" do
    user = users(:secondary)
    assert_not user.superuser?
  end

  test "requires username" do
    user = User.new(password: "password123", password_confirmation: "password123")
    assert_not user.valid?
    assert_includes user.errors[:username], "can't be blank"
  end

  test "requires unique username" do
    existing_user = users(:default)
    user = User.new(username: existing_user.username, password: "password123", password_confirmation: "password123")
    assert_not user.valid?
    assert_includes user.errors[:username], "has already been taken"
  end
end
