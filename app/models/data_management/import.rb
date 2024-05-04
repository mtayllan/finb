module DataManagement
  class Import
    def initialize(file)
      @data = JSON.parse(file.read)
    end

    def call
      clear_data
      insert_categories
      insert_accounts
      insert_transactions
      insert_transfers
      populate_account_balances
    end

    private

    def clear_data
      Transaction.delete_all
      Transfer.delete_all
      Account.delete_all
      Category.delete_all
    end

    def insert_categories
      Category.insert_all(@data["categories"])
    end

    def insert_accounts
      Account.insert_all(@data["accounts"])
    end

    def insert_transactions
      Transaction.insert_all(@data["transactions"])
    end

    def insert_transfers
      Transfer.insert_all(@data["transfers"])
    end

    def populate_account_balances
      Account.find_each(&:update_balance)
    end
  end
end
