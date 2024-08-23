import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from "stimulus-use"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ["transaction", "account", "category"]

  connect() {
    useClickOutside(this, { element: this.transactionTarget });
  }

  clickOutside() {
    this.closeDropdown();
  }

  transactionDropdown() {
    return this.transactionTarget.querySelector('div');
  }

  openDropdown() {
    this.transactionDropdown().classList.remove('hidden');
  }

  closeDropdown() {
    this.transactionDropdown().classList.add('hidden');
  }

  async search() {
    const query = this.transactionTarget.querySelector('input[type=text]').value.toLowerCase();
    if (query.length < 3) {
      this.closeDropdown();
      return;
    }

    const transactions = await get(`/transactions?q=${query}`, { responseKind: 'json' }).then(response => response.json);

    this.transactionDropdown().innerHTML = '';

    transactions.forEach(transaction => {
      const button = document.createElement('button');
      button.type = 'button';
      button.classList.add('flex', 'w-full', 'cursor-default', 'select-none', 'items-center', 'rounded-sm', 'py-1.5', 'pl-2', 'pr-8', 'text-sm', 'outline-none', 'hover:bg-accent', 'focus:bg-accent', 'focus:text-accent-foreground');
      button.dataset.action = 'transaction-search#selectOption';
      button.dataset['description'] = transaction.description;
      button.dataset['categoryId'] = transaction.category.id;
      button.dataset['categoryName'] = transaction.category.name;
      button.dataset['accountId'] = transaction.account.id;
      button.dataset['accountName'] = transaction.account.name;
      button.innerHTML = `
        <div class="flex flex-col text-left">
          <div>${transaction.description}</div>
          <div class="text-xs">
            <span style="color:${transaction.category.color}" class="text-xs">${transaction.category.name}</span>
            /
            <span style="color:${transaction.account.color}" class="text-xs">${transaction.account.name}</span>
          </div>
        </div>
      `;
      this.transactionDropdown().appendChild(button);
    });

    this.openDropdown()
  }

  selectOption(event) {
    this.transactionTarget.querySelector('input').value = event.currentTarget.dataset.description;

    const accountTextField = this.accountTarget.querySelector('input[type=text]');
    const accountHiddenField = this.accountTarget.querySelector('input[type=hidden]');
    accountTextField.value = event.currentTarget.dataset.accountName;
    accountHiddenField.value = event.currentTarget.dataset.accountId;
    accountHiddenField.dispatchEvent(new Event('change'));

    const categoryTextField = this.categoryTarget.querySelector('input[type=text]');
    const categoryHiddenField = this.categoryTarget.querySelector('input[type=hidden]');
    categoryTextField.value = event.currentTarget.dataset.categoryName;
    categoryHiddenField.value = event.currentTarget.dataset.categoryId;
    categoryHiddenField.dispatchEvent(new Event('change'));

    this.closeDropdown();
  }
}