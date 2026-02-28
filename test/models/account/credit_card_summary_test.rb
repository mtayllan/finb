require "test_helper"

class Account::CreditCardSummaryTest < ActiveSupport::TestCase
  # billing_month

  test "billing_month returns current month when expiration day is nil" do
    card = accounts(:credit_one).tap { |c| c.credit_card_expiration_day = nil }
    assert_equal Date.current.beginning_of_month, Account::CreditCardSummary.new(card).billing_month
  end

  test "billing_month returns current month when expiration day is still ahead" do
    travel_to Date.new(2026, 2, 15) do
      # credit_one has expiration_day: 20, which is ahead of the 15th
      assert_equal Date.new(2026, 2, 1), Account::CreditCardSummary.new(accounts(:credit_one)).billing_month
    end
  end

  test "billing_month returns next month when expiration day has already passed" do
    travel_to Date.new(2026, 2, 25) do
      # credit_one has expiration_day: 20, which has passed on the 25th
      assert_equal Date.new(2026, 3, 1), Account::CreditCardSummary.new(accounts(:credit_one)).billing_month
    end
  end

  # current_statement

  test "current_statement returns nil when no statement exists for billing month" do
    travel_to 6.months.from_now do
      card = accounts(:credit_one).tap { |c| c.credit_card_expiration_day = nil }
      assert_nil Account::CreditCardSummary.new(card).current_statement
    end
  end

  test "current_statement returns the statement matching the billing month" do
    card = accounts(:credit_one).tap { |c| c.credit_card_expiration_day = nil }
    assert_equal credit_card_statements(:cc_stmt_current), Account::CreditCardSummary.new(card).current_statement
  end

  # future_sum

  test "future_sum returns 0 when there are no future statements" do
    travel_to 6.months.from_now do
      card = accounts(:credit_one).tap { |c| c.credit_card_expiration_day = nil }
      assert_equal 0, Account::CreditCardSummary.new(card).future_sum
    end
  end

  test "future_sum sums only unpaid statements after the billing month" do
    card = accounts(:credit_one).tap { |c| c.credit_card_expiration_day = nil }
    # cc_stmt_next (300, unpaid) + cc_stmt_far (200, paid) → only 300 counted
    assert_equal 300, Account::CreditCardSummary.new(card).future_sum
  end

  # delegation

  test "delegates account attributes to the wrapped account" do
    card = accounts(:credit_one)
    summary = Account::CreditCardSummary.new(card)

    assert_equal card.id, summary.id
    assert_equal card.name, summary.name
    assert_equal card.color, summary.color
  end
end
