class Settings::ExportDataController < ApplicationController
  def create
    send_data(DataManagement::Export.new.to_json, filename: "finb.json", type: "application/json")
  end
end
