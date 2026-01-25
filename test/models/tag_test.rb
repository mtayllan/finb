require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "validations" do
    tag = Tag.new(name: "", color: "")
    assert_not tag.valid?
    assert_includes tag.errors[:name], "can't be blank"
    assert_includes tag.errors[:user], "must exist"

    tag.assign_attributes(name: "New Tag", color: "#ff0000", user: users(:default))
    assert tag.valid?
  end

  test "uniqueness of name scoped to user" do
    existing_tag = tags(:tropicalrb)
    new_tag = Tag.new(name: existing_tag.name, user: existing_tag.user)

    assert_not new_tag.valid?
    assert_includes new_tag.errors[:name], "has already been taken"
  end

  test "same name allowed for different users" do
    existing_tag = tags(:tropicalrb)
    new_tag = Tag.new(name: existing_tag.name, user: users(:secondary))

    assert new_tag.valid?
  end
end
