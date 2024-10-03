class Category < ApplicationRecord
  belongs_to :user

  validates :name, :color, :icon, presence: true
end
