class Category < ApplicationRecord
  validates :name, :color, :icon, presence: true

  def icon_svg
    Icons.fetch(icon.to_sym, background: color)
  end
end
