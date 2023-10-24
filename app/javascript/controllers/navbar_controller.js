import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobile"]

  toggle() {
    this.mobileTarget.classList.toggle("hidden")
  }
}
