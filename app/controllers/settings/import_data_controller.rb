class Settings::ImportDataController < ApplicationController
  def create
    file = params.permit(:file)[:file]

    DataManagement::Import.new(file).call

    redirect_to settings_path, notice: "Data imported successfully"
  end
end
