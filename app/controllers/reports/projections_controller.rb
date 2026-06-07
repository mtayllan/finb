class Reports::ProjectionsController < ApplicationController
  ALLOWED_MONTHS = [3, 6, 12].freeze
  DEFAULT_MONTHS = 6

  def show
    @months = params[:months].to_i
    @months = DEFAULT_MONTHS unless ALLOWED_MONTHS.include?(@months)

    @projection = Projection.new(user: Current.user, months: @months)
  end
end
