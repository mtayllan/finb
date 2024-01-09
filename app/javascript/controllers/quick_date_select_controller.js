import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { inputName: String }

  select(event) {
    console.log(event.params)
    document.querySelector(`input[name="${this.inputNameValue}"]`).value = event.params.value;
  }
}
