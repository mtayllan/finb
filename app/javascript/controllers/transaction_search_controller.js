import { Controller } from "@hotwired/stimulus"
import { useClickOutside, useDebounce } from "stimulus-use"
import { get } from "@rails/request.js"

export default class extends Controller {
  static targets = ["transaction", "account", "category"]
  static debounces = [{ name: "search", wait: 200 }]

  connect() {
    useClickOutside(this, { element: this.transactionTarget });
    useDebounce(this);
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

    const transactions = await get(`/similar_transactions?q=${query}`, { responseKind: 'json' }).then(response => response.json);

    this.transactionDropdown().innerHTML = '';

    transactions.forEach(transaction => {
      const button = document.createElement('button');
      button.type = 'button';
      button.classList.add('flex', 'w-full', 'cursor-default', 'select-none', 'items-center', 'rounded-sm', 'py-1.5', 'pl-2', 'pr-8', 'text-sm', 'outline-hidden', 'hover:bg-base-300', 'focus:bg-base-300');
      button.dataset.action = 'transaction-search#selectOption';
      button.dataset['description'] = transaction.description;
      button.dataset['categoryId'] = transaction.category_id;
      button.dataset['categoryName'] = transaction.category_name;
      button.dataset['accountId'] = transaction.account_id;
      button.dataset['accountName'] = transaction.account_name;
      button.innerHTML = `
        <div class="flex flex-col text-left">
          <div>${transaction.description}</div>
          <div class="text-xs">
            <span style="color:${transaction.category_color}" class="text-xs">${transaction.category_name}</span>
            /
            <span style="color:${transaction.account_color}" class="text-xs">${transaction.account_name}</span>
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
