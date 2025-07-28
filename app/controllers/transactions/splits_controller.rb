# frozen_string_literal: true

class Transactions::SplitsController < ApplicationController
  before_action :set_transaction
  before_action :set_split, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @split = @transaction.splits.build
  end

  def create
    @split = @transaction.splits.build(split_params)
    @split.payer = Current.user

    if @split.save
      redirect_to transactions_path, notice: "Split criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @split.update(split_params)
      redirect_to transactions_path, notice: "Split atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @split.destroy
    redirect_to transactions_path, notice: "Split removido com sucesso."
  end

  private

  def set_transaction
    @transaction = Current.user.transactions.find(params[:transaction_id])
  end

  def set_split
    @split = @transaction.splits.first
    redirect_to transactions_path, alert: "Split não encontrado." unless @split
  end

  def split_params
    params.require(:split).permit(:owes_to_id, :amount_owed, :owes_to_category_id)
  end
end
