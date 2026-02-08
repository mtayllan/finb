require "test_helper"

module DataManagement
  class ExportTest < ActiveSupport::TestCase
    test "should export valid JSON with all required keys" do
      export = Export.new
      json_string = export.to_json

      assert json_string.present?
      data = JSON.parse(json_string)

      expected_keys = %w[users categories accounts transactions transfers credit_card_statements splits tags transaction_tags chat_messages]
      assert_equal expected_keys.sort, data.keys.sort
    end

    test "should export actual data" do
      transaction = Transaction.create!(
        account: accounts(:bank_one),
        category: categories(:food),
        description: "Test export",
        value: 100,
        date: Date.current
      )

      export = Export.new
      data = JSON.parse(export.to_json)

      assert_operator data["transactions"].count, :>=, 1
      exported_transaction = data["transactions"].find { |t| t["id"] == transaction.id }
      assert_equal "Test export", exported_transaction["description"]
    end

    test "should exclude credit_card_statement_month from transactions" do
      export = Export.new
      data = JSON.parse(export.to_json)

      data["transactions"].each do |transaction|
        assert_not transaction.key?("credit_card_statement_month")
      end
    end

    test "should handle empty database" do
      ChatMessage.delete_all
      Split.delete_all
      TransactionTag.delete_all
      Tag.delete_all
      Transaction.delete_all
      Transfer.delete_all
      CreditCard::Statement.delete_all
      Account.delete_all
      Category.delete_all
      User.delete_all

      export = Export.new
      data = JSON.parse(export.to_json)

      assert_equal 0, data["users"].count
      assert_equal 0, data["transactions"].count
    end
  end
end
