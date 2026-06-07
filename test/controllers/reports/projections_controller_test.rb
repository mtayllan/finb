require "test_helper"

class Reports::ProjectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "renders the projection with the default horizon" do
    get reports_projection_url
    assert_response :success
    assert_select "option[selected][value=?]", "6"
  end

  test "honors an allowed horizon" do
    get reports_projection_url, params: {months: 12}
    assert_response :success
    assert_select "option[selected][value=?]", "12"
  end

  test "falls back to the default horizon when months is invalid" do
    get reports_projection_url, params: {months: 99}
    assert_response :success
    assert_select "option[selected][value=?]", "6"
  end
end
