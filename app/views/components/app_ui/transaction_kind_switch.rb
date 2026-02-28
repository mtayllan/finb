class AppUI::TransactionKindSwitch < ViewComponent::Base
  def initialize(form, transaction)
    @form = form
    @transaction = transaction
  end

  def checked?
    if @transaction.value.zero?
      @transaction.account&.investment?
    else
      @transaction.value > 0
    end
  end

  def state
    checked? ? "checked" : "unchecked"
  end

  def label_text
    checked? ? "Income" : "Expense"
  end

  def hidden_field_value
    checked? ? "income" : "expense"
  end
end
