module Transaction::Installmentable
  extend ActiveSupport::Concern

  class_methods do
    # Class method for creating installment transactions
    def create_with_installments(original_transaction, installments_count)
      installments_count = installments_count.to_i

      return original_transaction.save! if installments_count <= 1

      create_multiple_installments(original_transaction, installments_count)
    end

    private

    def create_multiple_installments(original_transaction, installments_count)
      # Store original values needed for calculations
      base_description = original_transaction.description
      base_value = original_transaction.value
      base_date = original_transaction.date

      # Calculate value per installment
      value_per_installment = (base_value / installments_count).round(2)

      # Handle rounding difference in the first installment
      first_installment_value = value_per_installment + (base_value - (value_per_installment * installments_count))

      transactions = []
      ActiveRecord::Base.transaction do
        installments_count.times do |i|
          # Create a new transaction for this installment
          installment = new_installment_from(original_transaction)

          # Set installment-specific attributes
          installment_number = i + 1
          installment.description = "#{base_description} (#{installment_number}/#{installments_count})"
          installment.value = (i == 0) ? first_installment_value : value_per_installment
          installment.date = base_date + i.months
          installment.save!

          transactions << installment
        end
      end

      transactions.first
    end

    def new_installment_from(transaction)
      new_transaction = new
      new_transaction.account_id = transaction.account_id
      new_transaction.category_id = transaction.category_id
      # Don't copy description, value and date as they will be set separately
      new_transaction
    end
  end
end
