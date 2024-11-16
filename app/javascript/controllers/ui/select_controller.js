import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ["searchInput", "inputValue", "dropdown"]

  connect() {
    useClickOutside(this);
    const currentValue = this.inputValueTarget.value;
    this.dropdownTarget.querySelectorAll('button').forEach(button => {
      if (button.dataset.value === currentValue) {
        this.searchInputTarget.value = button.textContent.trim();
      }
    });
  }

  clickOutside() {
    this.closeDropdown();
  }

  openDropdown() {
    this.dropdownTarget.classList.remove('hidden');
  }

  closeDropdown() {
    this.dropdownTarget.classList.add('hidden');
  }

  search() {
    const query = this.searchInputTarget.value.toLowerCase();
    this.dropdownTarget.querySelectorAll('button').forEach(button => {
      const buttonText = button.textContent.trim().toLowerCase();
      if (buttonText.includes(query)) {
        button.classList.remove('hidden');
      } else {
        button.classList.add('hidden');
      }
    });
  }

  selectOption(event) {
    this.searchInputTarget.value = event.currentTarget.textContent.trim();
    this.inputValueTarget.value = event.currentTarget.dataset.value;
    this.inputValueTarget.dispatchEvent(new Event('change'));
    this.closeDropdown();
  }
}
