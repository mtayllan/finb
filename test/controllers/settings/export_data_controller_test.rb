require "test_helper"

class Settings::ExportDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
  end

  test "should export data as JSON file" do
    post settings_export_data_url

    assert_response :success
    assert_equal "application/json", response.content_type
    assert_equal "attachment; filename=\"finb.json\"; filename*=UTF-8''finb.json", response.headers["Content-Disposition"]
  end
end
