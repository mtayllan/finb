require "test_helper"

class ProjectionTest < ActiveSupport::TestCase
  test "projects income, expenses and balance from the last 3 months without double counting installments" do
    travel_to Date.new(2026, 6, 15) do
      user = create(:user)
      account = create(:account, user:, kind: :checking, initial_balance: 0, initial_balance_date: Date.new(2026, 1, 1))
      groceries = create(:category, user:)
      pay = create(:category, user:)
      electronics = create(:category, user:)

      # Recurring expense: -100 in each of the 3 complete prior months (Mar/Apr/May)
      [Date.new(2026, 3, 10), Date.new(2026, 4, 10), Date.new(2026, 5, 10)].each do |date|
        create(:transaction, account:, category: groceries, value: -100, date:, description: "Groceries")
      end
      # Recurring income: 3000 in each of the 3 prior months
      [Date.new(2026, 3, 5), Date.new(2026, 4, 5), Date.new(2026, 5, 5)].each do |date|
        create(:transaction, account:, category: pay, value: 3000, date:, description: "Salary")
      end

      # A 3x installment bought in May: (1/3) is history, (2/3) and (3/3) are future.
      create(:transaction, account:, category: electronics, value: -90, date: Date.new(2026, 5, 20), description: "TV (1/3)")
      create(:transaction, account:, category: electronics, value: -90, date: Date.new(2026, 7, 20), description: "TV (2/3)")
      create(:transaction, account:, category: electronics, value: -90, date: Date.new(2026, 8, 20), description: "TV (3/3)")

      projection = Projection.new(user:, months: 2)

      july = Date.new(2026, 7, 1)
      august = Date.new(2026, 8, 1)

      # Horizon starts next month and has the requested length
      assert_equal [july, august], projection.future_months

      # Baseline = monthly average per category; installments excluded from baseline
      assert_equal(-100, projection.expense_baseline_by_category[groceries])
      assert_nil projection.expense_baseline_by_category[electronics]
      assert_equal 3000, projection.income_baseline_by_category[pay]

      # Each future month = recurring baseline (-100) + scheduled installment (-90)
      assert_equal(-190, projection.projected_expenses_by_month[july])
      assert_equal(-190, projection.projected_expenses_by_month[august])
      assert_equal 3000, projection.projected_income_by_month[july]

      assert_equal(-380, projection.total_projected_expenses)
      assert_equal 6000, projection.total_projected_income

      # Per-category over the horizon — no double counting: the May installment is
      # not in the baseline, so electronics only reflects the two future parts.
      assert_equal(-200, projection.projected_expense_by_category[groceries])
      assert_equal(-180, projection.projected_expense_by_category[electronics])

      # Running balance accumulates the monthly net on top of the current balance
      net = 3000 - 190
      assert_equal projection.starting_balance + net, projection.projected_balance_by_month[july]
      assert_equal projection.starting_balance + (2 * net), projection.projected_balance_by_month[august]
    end
  end
end
