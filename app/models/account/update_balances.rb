module Account::UpdateBalances
  def self.call(account, start_date: nil)
    start_date ||= account.initial_balance_date

    transactions = account.transactions.where(date: start_date..).order(:date)
    transfers_as_origin = account.transfers_as_origin.where(date: start_date..).order(:date)
    transfers_as_target = account.transfers_as_target.where(date: start_date..).order(:date)

    final_date = [transactions.last&.date, transfers_as_origin.last&.date, transfers_as_target.last&.date, Date.current].compact.max

    previous_balance =
      if start_date == account.initial_balance_date
        account.initial_balance
      else
        previous_balance_record = account.balances.where("date < ?", start_date).order(date: :desc).limit(1).first
        previous_balance_record&.balance || account.initial_balance
      end
    data = []
    start_date.upto(final_date) do |date|
      balance =
        previous_balance +
        transactions.select { |t| t.date == date }.sum(&:value) +
        transfers_as_target.select { |t| t.date == date }.sum(&:value) -
        transfers_as_origin.select { |t| t.date == date }.sum(&:value)

      next if balance == previous_balance
      previous_balance = balance

      data << {date:, account_id: account.id, balance:}
    end

    # Remove obsolete balance records in the date range that are no longer needed
    Account::Balance.where(account_id: account.id, date: start_date..).where.not(date: data.pluck(:date)).delete_all

    Account::Balance.upsert_all(data, unique_by: [:account_id, :date], update_only: [:balance])
  end
end
