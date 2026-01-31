require "test_helper"

module DataManagement
  class ImportTest < ActiveSupport::TestCase
    setup do
      @export_data = {
        "users" => [
          {
            "id" => 999,
            "username" => "import_test_user",
            "password_digest" => BCrypt::Password.create("password123"),
            "superuser" => false,
            "default_currency" => "USD"
          }
        ],
        "categories" => [
          {
            "id" => 999,
            "name" => "Import Test Category",
            "color" => "#ff0000",
            "icon" => "test",
            "user_id" => 999,
            "created_at" => Time.current.to_s,
            "updated_at" => Time.current.to_s
          }
        ],
        "accounts" => [
          {
            "id" => 999,
            "name" => "Import Test Account",
            "kind" => "checking",
            "initial_balance" => "0.0",
            "balance" => "0.0",
            "color" => "#00ff00",
            "user_id" => 999,
            "initial_balance_date" => Date.current.to_s,
            "created_at" => Time.current.to_s,
            "updated_at" => Time.current.to_s
          }
        ],
        "transactions" => [
          {
            "id" => 999,
            "account_id" => 999,
            "category_id" => 999,
            "description" => "Import test transaction",
            "value" => "100.0",
            "date" => Date.current.to_s,
            "exclude_from_reports" => false,
            "report_value" => "100.0",
            "created_at" => Time.current.to_s,
            "updated_at" => Time.current.to_s
          }
        ],
        "transfers" => [],
        "credit_card_statements" => [],
        "splits" => [],
        "tags" => [],
        "transaction_tags" => []
      }

      @file = StringIO.new(@export_data.to_json)
    end

    test "should import data successfully" do
      import = Import.new(@file)
      import.call

      assert_equal 1, User.count
      assert_equal 1, Category.count
      assert_equal 1, Account.count
      assert_equal 1, Transaction.count

      user = User.find(999)
      assert_equal "import_test_user", user.username
    end

    test "should clear existing data before import" do
      original_user_count = User.count
      assert original_user_count > 0

      import = Import.new(@file)
      import.call

      assert_equal 1, User.count
      assert_equal "import_test_user", User.first.username
    end

    test "should preserve referential integrity" do
      import = Import.new(@file)
      import.call

      transaction = Transaction.find(999)
      assert_equal 999, transaction.account_id
      assert_equal 999, transaction.category_id
      assert_equal "Import Test Account", transaction.account.name
      assert_equal "Import Test Category", transaction.category.name
    end

    test "should raise error on invalid JSON" do
      invalid_file = StringIO.new("{ invalid json")

      assert_raises(JSON::ParserError) do
        Import.new(invalid_file)
      end
    end
  end
end
