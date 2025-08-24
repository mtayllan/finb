module DataManagement
  class Import
    def initialize(file)
      @data = JSON.parse(file.read)
    end

    def call
      clear_data
      insert_data
      populate_account_balances
      populate_statement_values
    end

    private

    def clear_data
      Split.delete_all
      Transaction.delete_all
      Transfer.delete_all
      CreditCard::Statement.delete_all
      Account.delete_all
      Category.delete_all
      User.delete_all
    end

    def insert_data
      User.insert_all(@data["users"])
      Category.insert_all(@data["categories"])
      Account.insert_all(@data["accounts"])
      CreditCard::Statement.insert_all(@data["credit_card_statements"])
      Transfer.insert_all(@data["transfers"])
      Transaction.insert_all(@data["transactions"])
      Split.insert_all(@data["splits"])
    end

    def populate_account_balances
      Account.find_each(&:update_balance)
    end

    def populate_statement_values
      CreditCard::Statement.find_each(&:update_value)
    end
  end
end
