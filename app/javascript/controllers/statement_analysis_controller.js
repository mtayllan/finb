import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "row",
    "importCheckbox",
    "categorySelect",
    "selectAllCheckbox",
    "bulkCategorySelect",
    "selectedCount"
  ]

  connect() {
    this.updateSummary()
  }

  toggleAll(event) {
    const checked = event.target.checked

    this.importCheckboxTargets.forEach(checkbox => {
      checkbox.checked = checked
    })

    this.updateSummary()
  }

  applyBulkCategory(event) {
    event.preventDefault()

    const categoryId = this.bulkCategorySelectTarget.value

    if (!categoryId) {
      alert("Please select a category first")
      return
    }

    // Apply to all selected (checked) rows
    this.rowTargets.forEach((row, index) => {
      const checkbox = this.importCheckboxTargets[index]
      const categorySelect = this.categorySelectTargets[index]

      if (checkbox && checkbox.checked && categorySelect) {
        categorySelect.value = categoryId
      }
    })

    // Reset bulk selector
    this.bulkCategorySelectTarget.value = ""
  }

  updateSummary() {
    const checkedCount = this.importCheckboxTargets.filter(cb => cb.checked).length

    if (this.hasSelectedCountTarget) {
      this.selectedCountTarget.textContent = checkedCount
    }

    // Update "select all" checkbox state
    if (this.hasSelectAllCheckboxTarget) {
      const allChecked = this.importCheckboxTargets.length > 0 &&
                         this.importCheckboxTargets.every(cb => cb.checked)
      const someChecked = this.importCheckboxTargets.some(cb => cb.checked)

      this.selectAllCheckboxTarget.checked = allChecked
      this.selectAllCheckboxTarget.indeterminate = !allChecked && someChecked
    }
  }
}
