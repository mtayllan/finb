class SimilarTransactionsController < ApplicationController
  def index
    @transactions = Current.user.transactions
      .select(
        "transactions.description, transactions.category_id, transactions.account_id, " \
        "categories.name as category_name, categories.color as category_color, " \
        "accounts.name as account_name, accounts.color as account_color"
      )
      .joins(:category, :account)
      .where("lower(transactions.description) LIKE lower(?)", "%#{params[:q]}%")
      .group("transactions.description, transactions.category_id, transactions.account_id")
      .limit(5)

    render json: @transactions
  end
end
