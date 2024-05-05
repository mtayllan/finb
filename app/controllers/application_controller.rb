class ApplicationController < ActionController::Base
  before_action :authenticate

  def authenticate
    return if ENV.fetch("CREDENTIAL", "").split(":").size != 2
    return if cookies.signed[:authenticated]

    redirect_to sessions_url
  end
end
