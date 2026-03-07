class CreditCards::StatementPaymentsController < ApplicationController
  def new
    @credit_card = Current.user.accounts.where(kind: :credit_card).find(params[:credit_card_id])
    @month = Date.parse(params[:month])
    @statement = @credit_card.credit_card_statements.find_or_create_by(month: @month)
    @accounts = Current.user.accounts.where.not(id: @credit_card.id).order(:name)
  end

  def create
    credit_card = Current.user.accounts.where(kind: :credit_card).find(params[:credit_card_id])
    statement = credit_card.credit_card_statements.find(params[:statement_id])
    origin_account = Current.user.accounts.find(params[:origin_account_id])

    transfer = Transfer.create(
      origin_account: origin_account,
      target_account: credit_card,
      value: statement.value,
      description: "CC payment: #{statement.month.strftime("%B %Y")}",
      date: params[:date]
    )

    origin_account.update_balance(start_date: transfer.date)
    credit_card.update_balance(start_date: transfer.date)
    statement.update(paid_at: transfer.date)

    redirect_to credit_card_path(credit_card, month: statement.month), notice: "Statement paid successfully."
  end
end
