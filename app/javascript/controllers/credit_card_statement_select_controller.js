import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import {
  startOfMonth, addMonths, format, parse, addDays, setDay
} from "date-fns";

export default class extends Controller {
  static targets = ["statementMonthFormGroup"]

  async connect() {
    this.accountInput = this.element.querySelector('input[name="transaction[account_id]"]')
    this.accountInput.addEventListener('change', this.handleAccountChange.bind(this));

    this.dateInput = this.element.querySelector('input[name="transaction[date]"]');
    this.dateInput.addEventListener('change', this.handleDateChange.bind(this));

    this.statementSelectInput = this.statementMonthFormGroupTarget.querySelector('input[name="transaction[credit_card_statement]"]');

    const initialAccountId = this.accountInput.value;
    await this.toggleStatementFormGroup(initialAccountId);

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

    this.account = await get(`/accounts/${accountId}`, { responseKind: 'json' }).then(response => response.json);
    if (this.account.kind === 'credit_card') {
      this.statementMonthFormGroupTarget.classList.remove('hidden');
      this.statementSelectInput.disabled = false;
    } else {
      this.statementMonthFormGroupTarget.classList.add('hidden');
      this.statementSelectInput.disabled = true;
    }

    const initialDate = this.dateInput.value;
    if (initialDate) {
      this.renderStatementSelect(initialDate);
    }
  }

  renderStatementSelect(date) {
    if (!this.account) return;

    const parsedDate = parse(date, 'dd/MM/yyyy', new Date())
    const startOfMonthInSelectedDate = startOfMonth(parsedDate);
    const months = [-1, 0, 1].map(monthOffset => {
      const month = addMonths(startOfMonthInSelectedDate, monthOffset);
      return { value: format(month, 'dd/MM/yyyy'), label: format(month, 'MMM/yyyy') };
    })
    const expirationDate = setDay(startOfMonthInSelectedDate, this.account.credit_card_expiration_day);
    const lastStatementDate = addDays(expirationDate, -7);
    let defaultMonth = months[1]; // Default to current month
    if (parsedDate > lastStatementDate) {
      defaultMonth = months[2]; // If selected date is after last statement, use next month
    }

    this.statementSelectInput.nextElementSibling.querySelectorAll('button').forEach(button => {
      const month = months.pop();
      button.textContent = month.label;
      button.dataset.value = month.value;
    })
    this.statementSelectTextBox = this.statementMonthFormGroupTarget.querySelector('input[type="text"]');
    this.statementSelectTextBox.value = defaultMonth.label; // Set to current month label
    this.statementSelectInput.value = defaultMonth.value; // Set to current month
    this.statementSelectInput.dispatchEvent(new Event('change'));
  }

  disconnect() {
    this.accountInput.removeEventListener('change', this.handleAccountChange.bind(this));
    this.dateInput.removeEventListener('change', this.handleDateChange.bind(this));
  }
}
