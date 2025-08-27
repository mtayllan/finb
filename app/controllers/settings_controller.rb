class SettingsController < ApplicationController
  def show
  end

  def update_currency
    User.update(default_currency: params[:currency])

    redirect_to settings_path, notice: "Currency updated"
  end
end
