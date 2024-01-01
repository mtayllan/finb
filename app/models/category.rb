class Category < ApplicationRecord
  belongs_to :parent_category, optional: true

  has_many :sub_categories, class_name: "Category", foreign_key: "parent_category_id", dependent: :destroy
end
