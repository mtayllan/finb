require "test_helper"

class CreditCardTest < ActiveSupport::TestCase
  def setup
    @credit_card = credit_cards(:one)
  end

  test "should be valid with valid attributes" do
    assert @credit_card.valid?
  end

  test "should not be valid without expiration_day" do
    @credit_card.expiration_day = nil
    assert_not @credit_card.valid?
  end

  test "should not be valid with non-integer expiration_day" do
    @credit_card.expiration_day = "abc"
    assert_not @credit_card.valid?
  end

  test "should not be valid with expiration_day less than 1" do
    @credit_card.expiration_day = 0
    assert_not @credit_card.valid?
  end

  test "should not be valid with expiration_day greater than 31" do
    @credit_card.expiration_day = 32
    assert_not @credit_card.valid?
  end

  test "expiration_day_in_month should return correct day" do
    @credit_card.expiration_day = 15
    assert_equal 15, @credit_card.expiration_day_in_month(Date.new(2023, 1, 1))
  end

  test "expiration_day_in_month should return last day of month if expiration_day exceeds it" do
    @credit_card.expiration_day = 31
    assert_equal 28, @credit_card.expiration_day_in_month(Date.new(2023, 2, 1))
  end
end
