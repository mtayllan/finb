class StatementAnalysis < ApplicationRecord
  belongs_to :account
  belongs_to :credit_card_statement, class_name: "CreditCard::Statement", optional: true
  has_many :items, class_name: "StatementAnalysis::Item", dependent: :destroy

  enum :status, {pending: 0, completed: 1, cancelled: 2}

  validates :total_rows, presence: true, numericality: {greater_than: 0}

  def import_transactions!
    raise "Cannot import a completed analysis" if completed?

    importable_items = items.where(should_import: true)

    # Validate all importable items have categories
    items_without_category = importable_items.where(category_id: nil)
    if items_without_category.any?
      raise "All selected items must have a category assigned"
    end

    StatementAnalysis::Importer.new(self).import!
    update!(status: :completed)
  end

  def can_edit?
    pending?
  end
end
