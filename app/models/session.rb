class Session < ApplicationRecord
  has_secure_token

  def self.start_new_session
    destroy_oldest_session if Session.count > 5

    Session.create
  end

  def self.destroy_oldest_session
    Session.first.destroy
  end
end
