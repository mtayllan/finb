class ChatMessage < ApplicationRecord
  belongs_to :user, default: -> { Current.user }
  belongs_to :created_transaction, class_name: "Transaction", optional: true

  validates :message, presence: true

  scope :recent, -> { order(created_at: :desc).limit(50) }

  class ParseError < StandardError; end

  def process
    parsed_data = TransactionParser.new(self).parse
    transaction = Transaction.new(parsed_data)

    if transaction.save
      update!(response: Response.new(transaction).to_s, created_transaction: transaction)
      transaction
    else
      update!(response: "Error creating transaction: #{transaction.errors.full_messages.to_sentence}")
      nil
    end
  rescue ParseError => e
    update!(response: "Error parsing message: #{e.message}")
    nil
  end
end
