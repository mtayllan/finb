class Category < ApplicationRecord
  belongs_to :parent_category, optional: true

  has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id", dependent: :destroy

  validates :name, :color, :icon, presence: true

  def icon_svg
    Icons.fetch(icon.to_sym, background: color)
  end
end
