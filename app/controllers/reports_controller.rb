class ReportsController < ApplicationController
  def show
    @start_date = Date.parse(params[:start_date]) rescue 2.months.ago.beginning_of_month.to_date
    @end_date = Date.parse(params[:end_date]) rescue Date.today.end_of_month
    @granularity = params[:granularity].presence || "month"

    @income = Transaction.where("value > 0").group_by_period(@granularity, :date, range: @start_date..@end_date).sum(:value)
    @expenses = Transaction.where("value < 0").group_by_period(@granularity, :date, range: @start_date..@end_date).sum(:value)
  end

  def filter_params
    params.permit(:start_date, :end_date, :granularity)
  end
end
