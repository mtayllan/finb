import { Controller } from "@hotwired/stimulus"
import { useClickOutside } from 'stimulus-use'

export default class extends Controller {
  static targets = ["trigger", "dropdown", "chips", "placeholder", "hiddenInputs"]
  static values = { name: String }

  connect() {
    useClickOutside(this)
  }

  clickOutside() {
    this.closeDropdown()
  }

  toggleDropdown(event) {
    if (event.target.closest('[data-action*="removeChip"]')) return
    this.dropdownTarget.classList.toggle('hidden')
  }

  closeDropdown() {
    this.dropdownTarget.classList.add('hidden')
  }

  toggleOption(event) {
    const button = event.currentTarget
    const value = button.dataset.value
    const label = button.dataset.label
    const color = button.dataset.color
    const isSelected = button.dataset.selected === 'true'

    if (isSelected) {
      this.removeValue(value)
      button.dataset.selected = 'false'
      button.querySelector('[data-check]').classList.add('invisible')
    } else {
      this.addValue(value, label, color)
      button.dataset.selected = 'true'
      button.querySelector('[data-check]').classList.remove('invisible')
    }

    this.updatePlaceholder()
  }

  removeChip(event) {
    event.stopPropagation()
    const value = event.currentTarget.dataset.value
    this.removeValue(value)

    const optionButton = this.dropdownTarget.querySelector(`button[data-value="${value}"]`)
    if (optionButton) {
      optionButton.dataset.selected = 'false'
      optionButton.querySelector('[data-check]').classList.add('invisible')
    }

    this.updatePlaceholder()
  }

  addValue(value, label, color) {
    const chip = document.createElement('span')
    chip.className = 'inline-flex items-center gap-1 px-2 py-0.5 text-sm rounded-full bg-base-200'
    chip.dataset.chipValue = value

    let chipContent = ''
    if (color) {
      chipContent += `<span class="w-2 h-2 rounded-full" style="background-color: ${color}"></span>`
    }
    chipContent += `${label}<button type="button" class="hover:text-error" data-action="click->ui--multi-select-field#removeChip" data-value="${value}"><i class="ph ph-x text-xs"></i></button>`

    chip.innerHTML = chipContent
    this.chipsTarget.appendChild(chip)

    const input = document.createElement('input')
    input.type = 'hidden'
    input.name = this.nameValue
    input.value = value
    input.dataset.inputValue = value
    this.hiddenInputsTarget.appendChild(input)
  }

  removeValue(value) {
    const chip = this.chipsTarget.querySelector(`[data-chip-value="${value}"]`)
    if (chip) chip.remove()

    const input = this.hiddenInputsTarget.querySelector(`[data-input-value="${value}"]`)
    if (input) input.remove()
  }

  updatePlaceholder() {
    const hasChips = this.chipsTarget.children.length > 0
    if (hasChips) {
      this.placeholderTarget.classList.add('hidden')
    } else {
      this.placeholderTarget.classList.remove('hidden')
    }
  }
}
