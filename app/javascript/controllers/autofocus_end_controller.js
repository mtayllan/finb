import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.focus()
    this.element.setSelectionRange(this.element.value.length, this.element.value.length)
  }
}
