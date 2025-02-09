class CreditCard < ApplicationRecord
  belongs_to :user
  has_many :statements, dependent: :destroy, class_name: "CreditCard::Statement"

  validates :name, :limit, :color, :due_day, :closing_day, presence: true

  def current_statement
    statements.where(paid_at: nil).order(:due_date).first
  end
end
