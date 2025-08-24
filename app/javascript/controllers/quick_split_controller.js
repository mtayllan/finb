import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { transactionAmount: Number }
  static targets = ["amountInput"]

  split(event) {
    const fraction = parseFloat(event.target.dataset.fraction)
    const splitAmount = this.transactionAmountValue * fraction

    // Format the amount to 2 decimal places
    const formattedAmount = splitAmount.toFixed(2)

    // Update the input field
    this.amountInputTarget.value = formattedAmount

    // Trigger the money field formatting if it exists
    if (this.amountInputTarget.dataset.controller &&
      this.amountInputTarget.dataset.controller.includes('ui--money-field')) {
      // The MoneyField controller will format on connect, so we trigger that
      this.amountInputTarget.dispatchEvent(new Event('input', { bubbles: true }))
    }
  }
}
