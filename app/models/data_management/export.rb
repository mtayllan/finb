module DataManagement
  class Export
    def to_json
      {
        categories: Current.user.categories.map do |category|
          category.attributes.slice("id", "name", "color", "icon")
        end,
        accounts: Current.user.accounts.map do |account|
          account.attributes.slice("id", "name", "color", "balance", "initial_balance", "kind", "initial_balance_date", "credit_card_expiration_day")
        end,
        transactions: Current.user.transactions.all.map do |transaction|
          transaction.attributes.slice("id", "description", "value", "date", "category_id", "account_id", "credit_card_statement_id")
        end,
        transfers: Current.user.transfers.all.map do |transfer|
          transfer.attributes.slice("id", "description", "value", "date", "origin_account_id", "target_account_id")
        end,
        credit_card_statements: Current.user.credit_card_statements.all.map do |statement|
          statement.attributes.slice("id", "month", "account_id", "paid_at")
        end
      }.to_json
    end
  end
end
