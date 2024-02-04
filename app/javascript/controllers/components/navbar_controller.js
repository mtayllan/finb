import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ["mobile"]

  connect() {
    useClickOutside(this);
  }

  clickOutside() {
    this.mobileTarget.classList.add("hidden")
  }

  toggle() {
    this.mobileTarget.classList.toggle("hidden");
  }
}
