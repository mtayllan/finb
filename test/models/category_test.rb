require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "validations" do
    category = Category.new(name: "", color: "", icon: nil)
    assert_not category.valid?
    assert_includes category.errors[:name], "can't be blank"
    assert_includes category.errors[:color], "can't be blank"
    assert_includes category.errors[:icon], "can't be blank"

    category.assign_attributes(name: "Bank One", color: "#000", icon: "house")
    assert category.valid?
  end
end
