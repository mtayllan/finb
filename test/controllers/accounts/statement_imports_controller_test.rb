require "test_helper"

class Accounts::StatementImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_default_user
    @account = accounts(:bank_one)
  end

  test "should get new" do
    get new_account_statement_import_url(@account)
    assert_response :success
    assert_select "h1", /Import Statement/
  end

  test "should show error when no file is uploaded" do
    post account_statement_imports_url(@account), params: {}

    assert_redirected_to new_account_statement_import_url(@account)
    assert_equal "Please select a file", flash[:alert]
  end
end
