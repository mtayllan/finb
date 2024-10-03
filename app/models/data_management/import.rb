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
      Transaction.joins(:account).where({ account: { user_id: Current.user.id } }).delete_all
      Transfer.joins(:target_account).where({ target_account: { user_id: Current.user.id } }).delete_all
      Transfer.joins(:origin_account).where({ origin_account: { user_id: Current.user.id } }).delete_all
      Current.user.accounts.delete_all
      Current.user.categories.delete_all
    end

    def insert_categories
      @categories_map = {}
      @data["categories"].each do |category|
        params = category.except("id")
        params[:user] = Current.user
        record = Category.create(params)
        @categories_map[category["id"]] = record.id
      end
    end

    def insert_accounts
      @accounts_map = {}
      @data["accounts"].each do |account|
        params = account.except("id")
        params[:user] = Current.user
        record = Account.create(params)
        @accounts_map[account["id"]] = record.id
      end
    end

    def insert_transactions
      parsed_transactions = @data["transactions"].map do |transaction|
        transaction.except("id").merge({
          account_id: @accounts_map[transaction["account_id"]],
          category_id: @categories_map[transaction["category_id"]]
        })
      end
      Transaction.insert_all(parsed_transactions)
    end

    def insert_transfers
      parsed_transfers = @data["transfers"].map do |transfer|
        transfer.except("id").merge({
          target_account_id: @accounts_map[transfer["target_account_id"]],
          origin_account_id: @accounts_map[transfer["origin_account_id"]]
        })
      end
      Transfer.insert_all(parsed_transfers)
    end

    def populate_account_balances
      Current.user.accounts.find_each(&:update_balance)
    end
  end
end
