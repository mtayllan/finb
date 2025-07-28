import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="split-calculator"
export default class extends Controller {
  static targets = ["amountOwed", "transactionAmount", "suggestedAmounts"]
  static values = { transactionAmount: Number }

  connect() {
    this.updateSuggestions()
  }

  updateSuggestions() {
    if (this.hasSuggestedAmountsTarget) {
      const total = this.transactionAmountValue
      const suggestions = [
        { label: "50/50 Split", amount: total / 2 },
        { label: "1/3 Split", amount: total / 3 },
        { label: "2/3 Split", amount: (total * 2) / 3 },
        { label: "1/4 Split", amount: total / 4 },
        { label: "3/4 Split", amount: (total * 3) / 4 }
      ]

      this.suggestedAmountsTarget.innerHTML = suggestions
        .map(suggestion =>
          `<button type="button" class="btn btn-outline btn-sm"
                   data-action="click->split-calculator#setSuggestedAmount"
                   data-amount="${suggestion.amount.toFixed(2)}">
             ${suggestion.label} (${this.formatCurrency(suggestion.amount)})
           </button>`
        ).join(' ')
    }
  }

  setSuggestedAmount(event) {
    const amount = event.currentTarget.dataset.amount
    if (this.hasAmountOwedTarget) {
      this.amountOwedTarget.value = amount
      this.amountOwedTarget.focus()
    }
  }

  validateAmount() {
    if (this.hasAmountOwedTarget) {
      const currentAmount = parseFloat(this.amountOwedTarget.value) || 0
      const maxAmount = this.transactionAmountValue

      if (currentAmount > maxAmount) {
        this.amountOwedTarget.value = maxAmount.toFixed(2)
      }

      if (currentAmount < 0) {
        this.amountOwedTarget.value = "0.00"
      }
    }
  }

  formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount)
  }
}
