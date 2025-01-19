require "test_helper"

class CreditCard::StatementTest < ActiveSupport::TestCase
  def setup
    @credit_card = credit_cards(:one)
    @statement = CreditCard::Statement.new(credit_card: @credit_card, due_date: Date.today)
  end

  test "should be valid with valid attributes" do
    assert @statement.valid?
  end

  test "should be invalid without a due date" do
    @statement.due_date = nil
    assert_not @statement.valid?
  end

  test "should belong to a credit card" do
    assert_equal @credit_card, @statement.credit_card
  end
end
