class ChatMessage::Response
  include ActionView::Helpers::NumberHelper

  def initialize(transaction)
    @transaction = transaction
  end

  def to_s
    parts = []
    parts << "Created: #{@transaction.description}"
    parts << "Value: #{number_to_currency(@transaction.value.abs, unit: "R$ ")}"
    parts << "Date: #{@transaction.date.strftime("%d/%m/%Y")}"
    parts << "Account: #{@transaction.account&.name || "Not specified"}"
    parts << "Category: #{@transaction.category&.name || "Not specified"}"
    parts.join(" | ")
  end
end
