import { Controller } from "@hotwired/stimulus"
import { get } from "@rails/request.js"
import {
  startOfMonth, addMonths, format, parse, addDays, setDate
} from "date-fns";

export default class extends Controller {
  static targets = ["statementMonthFormGroup"]

  async connect() {
    this.accountInput = this.element.querySelector('input[name="transaction[account_id]"]')
    this.accountInput.addEventListener('change', this.handleAccountChange.bind(this));

    this.dateInput = this.element.querySelector('input[name="transaction[date]"]');
    this.dateInput.addEventListener('change', this.handleDateChange.bind(this));

    this.statementSelectInput = this.statementMonthFormGroupTarget.querySelector('input[name="transaction[credit_card_statement_month]"]');

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

    const parsedDate = parse(date, 'dd/MM/yyyy', new Date());
    // calculate the statement month for the selected date
    let expirationDateOnMonth = setDate(parsedDate, this.account.credit_card_expiration_day);
    if (parsedDate > expirationDateOnMonth) {
      expirationDateOnMonth = addMonths(expirationDateOnMonth, 1);
    }
    const closingDate = addDays(expirationDateOnMonth, -7);
    let defaultStatementMonth;
    if (closingDate > parsedDate) {
      defaultStatementMonth = startOfMonth(expirationDateOnMonth)
    } else {
      defaultStatementMonth = startOfMonth(addMonths(expirationDateOnMonth, 1));
    }

    // Generate proximate months around the default statement month
    const startOfMonthInSelectedStatement = startOfMonth(defaultStatementMonth);
    const months = [-1, 0, 1].map(monthOffset => {
      const month = addMonths(startOfMonthInSelectedStatement, monthOffset);
      return { value: format(month, 'dd/MM/yyyy'), label: format(month, 'MMM/yyyy') };
    })
    const defaultMonth = months[1];

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
