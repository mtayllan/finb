require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "validations" do
    category = Category.new(name: "", color: "", icon: nil)
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
    assert_includes category.errors[:color], "can't be blank"
    assert_includes category.errors[:icon], "can't be blank"
    assert_includes category.errors[:user], "must exist"

    category.assign_attributes(name: "Category One", color: "#000", icon: "house", user: users(:default))
    assert category.valid?
  end
end
