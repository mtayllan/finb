class AppUI::Transactions::Row < ViewComponent::Base
  include ApplicationHelper

  def initialize(transaction, show_account: false, show_split_actions: true, return_to_transactions: false, show_installment_indicator: false)
    @transaction = transaction
    @show_account = show_account
    @show_split_actions = show_split_actions
    @return_to_transactions = return_to_transactions
    @show_installment_indicator = show_installment_indicator
  end

  private

  attr_reader :transaction

  def future?
    transaction.date > Date.current
  end

  def installment?
    @show_installment_indicator && transaction.installment?
  end

  def value_class
    (transaction.value >= 0) ? "text-positive" : "text-negative"
  end

  def category_url
    url_for(params.permit(:month, :account_id, :category_id, :search).merge(category_id: transaction.category_id))
  end

  def account_url
    url_for(params.permit(:month, :category_id, :search).merge(account_id: transaction.account_id))
  end

  def split_link_options
    @return_to_transactions ? {return_to_transactions: true} : {}
  end
end
