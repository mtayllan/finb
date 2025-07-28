# frozen_string_literal: true

module Splittable
  extend ActiveSupport::Concern

  included do
    has_many :splits_as_payer, class_name: "Split", foreign_key: "payer_id", dependent: :destroy
    has_many :splits_as_owes_to, class_name: "Split", foreign_key: "owes_to_id", dependent: :destroy
  end

  def all_splits
    Split.where("payer_id = ? OR owes_to_id = ?", id, id)
  end

  def splits_for_view(view_type)
    case view_type
    when "from_me"
      splits_as_payer.includes(:source_transaction, :payer, :owes_to, :owes_to_category)
    when "to_me"
      splits_as_owes_to.includes(:source_transaction, :payer, :owes_to, :owes_to_category)
    when "summary"
      all_splits.includes(:source_transaction, :payer, :owes_to, :owes_to_category)
    else
      splits_as_payer.includes(:source_transaction, :payer, :owes_to, :owes_to_category)
    end
  end

  def total_amount_owed_by_me
    splits_as_payer.unpaid.sum(:amount_owed)
  end

  def total_amount_owed_to_me
    splits_as_owes_to.unpaid.sum(:amount_owed)
  end

  def net_split_balance
    total_amount_owed_to_me - total_amount_owed_by_me
  end

  def splits_summary
    {
      total_i_owe: total_amount_owed_by_me,
      count_i_owe: splits_as_payer.unpaid.count,
      total_owed_to_me: total_amount_owed_to_me,
      count_owed_to_me: splits_as_owes_to.unpaid.count,
      net_balance: net_split_balance
    }
  end
end
