import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const button = this.element.querySelector('button');
    const span = this.element.querySelector('span');
    const label = this.element.querySelector('label');
    const input = this.element.querySelector('input');
    if (button.dataset.state === 'unchecked') {
      button.dataset.state = 'checked';
      span.dataset.state = 'checked';
      label.textContent = 'Income';
      input.value = 'income';
    } else {
      button.dataset.state = 'unchecked';
      span.dataset.state = 'unchecked';
      label.textContent = 'Expense';
      input.value = 'expense';
    }
  }
}
