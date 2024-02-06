import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  select(event) {
    this.element.querySelector('input').value = event.params.color;
    this.element.querySelectorAll('button').forEach((button) => {
      button.dataset.active = false;
    });
    event.currentTarget.dataset.active = true;
  }
}
