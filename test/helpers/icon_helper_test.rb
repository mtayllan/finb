require "test_helper"

class IconHelperTest < ActionView::TestCase
  test "render an svg with the icon" do
    assert_equal render_icon('student', size: 10, background: "#ffffff", fill: "black"),
    <<~HTML
      <svg
        xmlns="http://www.w3.org/2000/svg"
        width="10" height="10"
        fill="black"
        viewBox="0 0 340 340">
        <circle cx="170" cy="170" r="170" fill="#ffffff" />
        <path d="#{IconHelper.const_get(:PATHS)[:student]}" transform="translate(42, 42)"></path>
      </svg>
    HTML
  end
end
