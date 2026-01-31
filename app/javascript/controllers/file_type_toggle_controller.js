import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["csvFields", "pdfFields", "csvInput", "pdfInput"]

  connect() {
    this.toggle()
  }

  toggle() {
    const fileType = this.element.querySelector('input[name="file_type"]:checked').value

    if (fileType === "csv") {
      this.csvFieldsTarget.classList.remove("hidden")
      this.pdfFieldsTarget.classList.add("hidden")
      this.csvInputTarget.required = true
      this.pdfInputTarget.required = false
    } else {
      this.csvFieldsTarget.classList.add("hidden")
      this.pdfFieldsTarget.classList.remove("hidden")
      this.csvInputTarget.required = false
      this.pdfInputTarget.required = true
    }
  }
}
