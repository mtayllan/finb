require "test_helper"

class Settings::ImportDataControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user # default user is a superuser

    @valid_import_data = {
      "users" => [],
      "categories" => [],
      "accounts" => [],
      "transactions" => [],
      "transfers" => [],
      "credit_card_statements" => [],
      "splits" => [],
      "tags" => [],
      "transaction_tags" => []
    }

    @valid_file = Rack::Test::UploadedFile.new(
      StringIO.new(@valid_import_data.to_json),
      "application/json",
      original_filename: "test_import.json"
    )
  end

  test "should import data successfully as superuser" do
    post settings_import_data_url, params: {file: @valid_file}

    assert_redirected_to settings_path
    assert_equal "Data imported successfully", flash[:notice]
  end

  test "should deny import for non-superuser" do
    delete sessions_path(parsed_cookies.signed[:session_token])
    post sessions_path, params: {username: "sister", password: "asd456"}

    post settings_import_data_url, params: {file: @valid_file}

    assert_redirected_to settings_path
    assert_equal "Only super users can import data", flash[:alert]
  end
end
