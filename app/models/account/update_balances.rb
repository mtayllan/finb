module Account::UpdateBalances
  def self.call(account)
    start_date = account.initial_balance_date

    transactions = account.transactions.where(date: start_date..).order(:date)
    transfers_as_origin = account.transfers_as_origin.where(date: start_date..).order(:date)
    transfers_as_target = account.transfers_as_target.where(date: start_date..).order(:date)

    final_date = [transactions.last&.date, transfers_as_origin.last&.date, transfers_as_target.last&.date, Date.current].compact.max

    previous_balance = account.initial_balance
    data = []
    start_date.upto(final_date) do |date|
      balance =
        previous_balance +
        transactions.select { |it| it.date == date }.sum(&:value) +
        transfers_as_target.select { |it| it.date == date }.sum(&:value) -
        transfers_as_origin.select { |it| it.date == date }.sum(&:value)

      next if balance == previous_balance
      previous_balance = balance

      data << {date:, account_id: account.id, balance:}
    end

    Account::Balance.upsert_all(data, unique_by: [:account_id, :date], update_only: [:balance])
  end
end
