class ReportsController < ApplicationController
  def show
    apply_quick_filter if params[:quick_filter].present?

    @start_date = begin
      Date.parse(params[:start_date])
    rescue
      Date.current.beginning_of_month
    end
    @end_date = begin
      Date.parse(params[:end_date])
    rescue
      Date.current.end_of_month
    end

    @granularity = params[:granularity].presence || "total"
    @categories = Current.user.categories.order(:name)
    @accounts = Current.user.accounts.order(:name)

    @selected_category_id = params[:category_id]
    @selected_account_id = params[:account_id]

    transactions = Current.user.transactions.where(date: @start_date..@end_date)
    transactions = transactions.where(category_id: @selected_category_id) if @selected_category_id.present?
    transactions = transactions.where(account_id: @selected_account_id) if @selected_account_id.present?

    if @granularity == "total"
      @total_income = transactions.where("value > 0").sum(:value)
      # Use report_value because of splits but only on expenses as there are no splits for income transactions
      @total_expenses = transactions.where("value < 0").sum(:report_value)
    else
      @income_by_period = transactions.where("value > 0").group_by_period(@granularity, :date, range: @start_date..@end_date).sum(:value)
      @expenses_by_period = transactions.where("value < 0").group_by_period(@granularity, :date, range: @start_date..@end_date).sum(:report_value)

      @total_income = @income_by_period.values.sum
      @total_expenses = @expenses_by_period.values.sum
    end

    @net_total = @total_income + @total_expenses

    @category_totals = transactions.group_by(&:category).map { |k, v| [k, v.sum(&:report_value)] }.sort_by { |_, v| v.abs }.reverse.to_h
    @account_totals = transactions.joins(:account).group(:account).sum(:value).sort_by { |_, v| v.abs }.reverse.to_h

    # For backwards compatibility with the chart
    @income = @income_by_period || {}
    @expenses = @expenses_by_period || {}
  end

  private

  def apply_quick_filter
    case params[:quick_filter]
    when "today"
      params[:start_date] = Date.current.to_s
      params[:end_date] = Date.current.to_s
    when "this_week"
      params[:start_date] = Date.current.beginning_of_week.to_s
      params[:end_date] = Date.current.end_of_week.to_s
    when "last_week"
      params[:start_date] = 1.week.ago.beginning_of_week.to_s
      params[:end_date] = 1.week.ago.end_of_week.to_s
    when "last_2_weeks"
      params[:start_date] = 2.weeks.ago.to_date.to_s
      params[:end_date] = Date.current.to_s
    when "this_month"
      params[:start_date] = Date.current.beginning_of_month.to_s
      params[:end_date] = Date.current.end_of_month.to_s
    when "last_month"
      params[:start_date] = 1.month.ago.beginning_of_month.to_s
      params[:end_date] = 1.month.ago.end_of_month.to_s
    when "last_3_months"
      params[:start_date] = 3.months.ago.to_date.to_s
      params[:end_date] = Date.current.to_s
    when "this_year"
      params[:start_date] = Date.current.beginning_of_year.to_s
      params[:end_date] = Date.current.end_of_year.to_s
    end
  end
end
