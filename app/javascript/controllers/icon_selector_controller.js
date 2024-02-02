import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["iconInput"]

  select(event) {
    const selectedButton = event.currentTarget;
    this.iconInputTarget.value = selectedButton.dataset['iconName']

    document.querySelectorAll('#icons-list > button').forEach(button => {
      if (button.dataset['iconName'] === selectedButton.dataset['iconName']) {
        button.classList.add('bg-accent')
      } else {
        button.classList.remove('bg-accent')
      }
    });
  }
}
