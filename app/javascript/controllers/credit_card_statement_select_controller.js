import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import {
  startOfMonth, addMonths, format, parse
} from "date-fns";

export default class extends Controller {
  static targets = ["statementMonthFormGroup"]

  connect() {
    this.accountInput = this.element.querySelector('input[name="transaction[account_id]"]')
    this.accountInput.addEventListener('change', this.handleAccountChange.bind(this));

    this.dateInput = this.element.querySelector('input[name="transaction[date]"]');
    this.dateInput.addEventListener('change', this.handleDateChange.bind(this));

    this.statementSelectInput = this.statementMonthFormGroupTarget.querySelector('input[name="transaction[credit_card_statement]"]');

    const initialAccountId = this.accountInput.value;
    this.toggleStatementFormGroup(initialAccountId);

    const initialDate = this.dateInput.value;
    if (initialDate) {
      this.renderStatementSelect(initialDate);
    }
  }

  handleAccountChange(event) {
    const selectedAccountId = event.target.value;
    this.toggleStatementFormGroup(selectedAccountId);
  }

  handleDateChange(event) {
    this.renderStatementSelect(event.target.value);
  }

  async toggleStatementFormGroup(accountId) {
    if (!accountId) {
      this.statementMonthFormGroupTarget.classList.add('hidden');
      this.statementSelectInput.disabled = true;
      return;
    }

    const account = await get(`/accounts/${accountId}`, { responseKind: 'json' }).then(response => response.json);
    if (account.kind === 'credit_card') {
      this.statementMonthFormGroupTarget.classList.remove('hidden');
      this.statementSelectInput.disabled = false;
    } else {
      this.statementMonthFormGroupTarget.classList.add('hidden');
      this.statementSelectInput.disabled = true;
    }
  }

  renderStatementSelect(date) {
    const startOfMonthInSelectedDate = startOfMonth(parse(date, 'dd/MM/yyyy', new Date()));
    const months = [-1, 0, 1].map(monthOffset => {
      const month = addMonths(startOfMonthInSelectedDate, monthOffset);
      return { value: format(month, 'dd/MM/yyyy'), label: format(month, 'MMM/yyyy') };
    })
    const currentMonth = months[1]; // Current month is the middle one
    this.statementSelectInput.nextElementSibling.querySelectorAll('button').forEach(button => {
      const month = months.pop();
      button.textContent = month.label;
      button.dataset.value = month.value;
    })
    this.statementSelectTextBox = this.statementMonthFormGroupTarget.querySelector('input[type="text"]');
    this.statementSelectTextBox.value = currentMonth.label; // Set to current month label
    this.statementSelectInput.value = currentMonth.value; // Set to current month
    this.statementSelectInput.dispatchEvent(new Event('change'));
  }

  disconnect() {
    this.accountInput.removeEventListener('change', this.handleAccountChange.bind(this));
    this.dateInput.removeEventListener('change', this.handleDateChange.bind(this));
  }
}
