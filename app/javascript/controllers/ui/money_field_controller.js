import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    let number = parseFloat(this.element.value);
    if (isNaN(number)) number = 0;

    this.element.value = (number).toFixed(2);
  }

  format() {
    const value = this.element.value;
    let number = parseInt(value.replace(/[^0-9]/g, ''));
    if (isNaN(number)) number = 0;

    this.element.value = (number / 100.0).toFixed(2);
  }
}
