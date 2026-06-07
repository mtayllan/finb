# Projects the user's future income, expenses and running balance based on the
# last few complete months of activity.
#
# Method (per the product decision):
# - Recurring baseline = monthly average per category over the last 3 complete
#   months, EXCLUDING installments (so financed purchases are not treated as
#   recurring spending).
# - Already-scheduled future transactions (installments and any future-dated
#   entries) are added on top as "known" amounts. Because installments are
#   excluded from the baseline, nothing is double counted.
# - Running balance starts from the current account balances (which only include
#   transactions up to today) and accumulates the projected monthly net.
class Projection
  HISTORY_MONTHS = 3

  attr_reader :months, :today

  def initialize(user:, months: 6, today: Date.current)
    @user = user
    @months = months.to_i
    @today = today
  end

  # Beginning-of-month dates for the projection horizon, starting next month.
  def future_months
    @future_months ||= Array.new(@months) { |i| first_future_month >> i }
  end

  # Current net worth across accounts (only counts transactions up to today).
  def starting_balance
    @starting_balance ||= @user.accounts.sum(:balance)
  end

  # { Category => monthly average } — negative values.
  def expense_baseline_by_category
    baselines[:expense]
  end

  # { Category => monthly average } — positive values.
  def income_baseline_by_category
    baselines[:income]
  end

  # { month_date => signed amount (negative) }
  def projected_expenses_by_month
    @projected_expenses_by_month ||= future_months.index_with do |month|
      baseline_expense_total + future_known[:expense][month].values.sum
    end
  end

  # { month_date => signed amount (positive) }
  def projected_income_by_month
    @projected_income_by_month ||= future_months.index_with do |month|
      baseline_income_total + future_known[:income][month].values.sum
    end
  end

  # { month_date => income + expenses }
  def net_by_month
    @net_by_month ||= future_months.index_with do |month|
      projected_income_by_month[month] + projected_expenses_by_month[month]
    end
  end

  # { month_date => running balance }
  def projected_balance_by_month
    @projected_balance_by_month ||= begin
      running = starting_balance
      future_months.index_with do |month|
        running += net_by_month[month]
        running
      end
    end
  end

  def total_projected_income
    projected_income_by_month.values.sum
  end

  def total_projected_expenses
    projected_expenses_by_month.values.sum
  end

  def total_net
    total_projected_income + total_projected_expenses
  end

  # { Category => signed total over the whole horizon }, sorted by magnitude.
  def projected_expense_by_category
    @projected_expense_by_category ||= aggregate_by_category(:expense)
  end

  def projected_income_by_category
    @projected_income_by_category ||= aggregate_by_category(:income)
  end

  private

  def first_future_month
    @today.beginning_of_month >> 1
  end

  def history_start
    @today.beginning_of_month << HISTORY_MONTHS
  end

  def history_end
    @today.beginning_of_month - 1.day
  end

  def baseline_expense_total
    expense_baseline_by_category.values.sum
  end

  def baseline_income_total
    income_baseline_by_category.values.sum
  end

  # Recurring monthly averages per category over the last HISTORY_MONTHS complete
  # months, excluding installments.
  def baselines
    @baselines ||= begin
      transactions = @user.transactions
        .where(exclude_from_reports: false, date: history_start..history_end)
        .includes(:category)
        .reject(&:installment?)

      expenses, incomes = transactions.partition { |t| t.value.negative? }

      {
        expense: average_by_category(expenses, &:report_value),
        income: average_by_category(incomes, &:value)
      }
    end
  end

  def average_by_category(transactions, &amount)
    transactions
      .group_by(&:category)
      .transform_values { |list| list.sum { |t| amount.call(t) || t.value } / HISTORY_MONTHS.to_f }
  end

  # { :expense => { month => { Category => signed sum } }, :income => { ... } }
  # Every future month is present (defaulting to {}).
  def future_known
    @future_known ||= begin
      range = future_months.first.beginning_of_month..future_months.last.end_of_month
      transactions = @user.transactions
        .where(exclude_from_reports: false, date: range)
        .includes(:category)

      known = {expense: empty_month_hash, income: empty_month_hash}
      transactions.each do |transaction|
        month = transaction.date.beginning_of_month
        next unless future_months.include?(month)

        expense = transaction.value.negative?
        bucket = known[expense ? :expense : :income][month]
        amount = expense ? (transaction.report_value || transaction.value) : transaction.value
        bucket[transaction.category] = (bucket[transaction.category] || 0) + amount
      end
      known
    end
  end

  def empty_month_hash
    future_months.index_with { {} }
  end

  def aggregate_by_category(type)
    totals = Hash.new(0)
    baseline = (type == :expense) ? expense_baseline_by_category : income_baseline_by_category
    baseline.each { |category, average| totals[category] += average * @months }
    future_known[type].each_value do |by_category|
      by_category.each { |category, amount| totals[category] += amount }
    end
    totals.sort_by { |_, value| value.abs }.reverse.to_h
  end
end
