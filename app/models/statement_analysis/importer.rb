class StatementAnalysis::Importer
  def initialize(statement_analysis)
    @statement_analysis = statement_analysis
  end

  def import!
    ActiveRecord::Base.transaction do
      @statement_analysis.items.where(should_import: true).find_each do |item|
        create_transaction_from_item(item)
      end
    end
  end

  private

  def create_transaction_from_item(item)
    Transaction.create!(
      account: @statement_analysis.account,
      credit_card_statement: @statement_analysis.credit_card_statement,
      category: item.category,
      description: item.description,
      date: item.date,
      value: item.calculated_value
    )
  end
end
