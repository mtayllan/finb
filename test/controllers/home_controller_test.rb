require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should get index" do
    get root_url
    assert_response :success
  end
end
