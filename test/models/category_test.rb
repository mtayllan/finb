require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "#icon_svg" do
    category = Category.new(name: "Test Category", color: "red", icon: :game)
    assert_equal category.icon_svg, Category::Icons.fetch(:game, background: "red")
  end
end
