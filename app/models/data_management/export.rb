module DataManagement
  class Export
    def to_json
      {
        users: User.all.map(&:attributes),
        categories: Category.find_each.map(&:attributes),
        accounts: Account.find_each.map(&:attributes),
        transactions: Transaction.find_each.map do |transaction|
          transaction.attributes.except("credit_card_statement_month")
        end,
        transfers: Transfer.find_each.map(&:attributes),
        credit_card_statements: CreditCard::Statement.find_each.map(&:attributes),
        splits: Split.find_each.map(&:attributes),
        tags: Tag.find_each.map(&:attributes),
        transaction_tags: TransactionTag.find_each.map(&:attributes),
        chat_messages: ChatMessage.find_each.map(&:attributes)
      }.to_json
    end
  end
end
