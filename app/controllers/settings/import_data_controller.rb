class Settings::ImportDataController < ApplicationController
  def create
    file = params.permit(:file)[:file]

    if Current.user.super?
      DataManagement::Import.new(file).call
      redirect_to settings_path, notice: "Data imported successfully"
    else
      redirect_to settings_path, alert: "Only super users can import data"
    end
  end
end
