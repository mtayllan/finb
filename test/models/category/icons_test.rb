require "test_helper"

class Category::IconsTest < ActiveSupport::TestCase
  test "fetches the icon for the given name" do
    assert_equal Category::Icons.fetch(:student, size: 10, background: "#ffffff", fill: "black"),
    <<~HTML
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="10" height="10"
        fill="black"
        viewBox="0 0 340 340">
        <circle cx="170" cy="170" r="170" fill="#ffffff" />
        <path d="#{Category::Icons::PATHS[:student]}" transform="translate(42, 42)"></path>
      </svg>
    HTML
  end
end
