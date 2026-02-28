class Account::CreditCardSummary < SimpleDelegator
  def current_statement
    @current_statement ||= credit_card_statements.find_by(month: billing_month)
  end

  def future_sum
    @future_sum ||= credit_card_statements
      .where(paid_at: nil)
      .where("month > ?", billing_month)
      .sum(:value)
  end

  def billing_month
    @billing_month ||= begin
      return Date.current.beginning_of_month if credit_card_expiration_day.nil?

      expiration_date = Date.current.change(day: credit_card_expiration_day)
      if expiration_date > Date.current
        Date.current.beginning_of_month
      else
        Date.current.beginning_of_month + 1.month
      end
    end
  end
end
