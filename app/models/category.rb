class Category < ApplicationRecord
  validates :name, :color, :icon, presence: true
end
