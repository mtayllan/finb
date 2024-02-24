module Account::UpdateBalances
  def self.call(account)
    start_date = account.created_at.to_date

    transactions = account.transactions.where(date: start_date..)
    transfers_as_origin = account.transfers_as_origin.where(date: start_date..)
    transfers_as_target = account.transfers_as_target.where(date: start_date..)

    previous_balance = account.balances.find_by(date: start_date - 1.day)&.balance || account.initial_balance
    data = []
    start_date.upto(Date.current) do |date|
      balance =
        previous_balance +
        transactions.select { |it| it.date == date }.sum(&:value) +
        transfers_as_target.select { |it| it.date == date }.sum(&:value) -
        transfers_as_origin.select { |it| it.date == date }.sum(&:value)

      next if balance == previous_balance
      previous_balance = balance

      data << { date:, account_id: account.id, balance: }
    end

    Account::Balance.upsert_all(data, unique_by: [:account_id, :date], update_only: [:balance])
  end
end
