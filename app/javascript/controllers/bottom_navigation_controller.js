import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["actions", "actionItem", "menu", "overlay", "addButton", "addIcon", "closeIcon", "menuButton", "menuIcon", "menuCloseIcon"]

  actionsOpen = false

  toggleActions() {
    if (this.menuTarget.classList.contains("translate-y-0")) {
      this.closeMenu()
    }

    if (this.actionsOpen) {
      this.closeActions()
    } else {
      this.openActions()
    }
  }

  openActions() {
    this.actionsOpen = true
    this.overlayTarget.classList.remove("hidden")
    this.actionsTarget.classList.remove("pointer-events-none")
    this.addIconTarget.classList.add("hidden")
    this.closeIconTarget.classList.remove("hidden")

    this.actionItemTargets.forEach((item, i) => {
      item.style.transitionDelay = `${i * 50}ms`
      item.classList.remove("scale-0", "opacity-0")
      item.classList.add("scale-100", "opacity-100")
    })
  }

  closeActions() {
    this.actionsOpen = false
    this.addIconTarget.classList.remove("hidden")
    this.closeIconTarget.classList.add("hidden")
    this.actionsTarget.classList.add("pointer-events-none")

    this.actionItemTargets.forEach((item) => {
      item.style.transitionDelay = "0ms"
      item.classList.remove("scale-100", "opacity-100")
      item.classList.add("scale-0", "opacity-0")
    })

    if (this.menuTarget.classList.contains("translate-y-full")) {
      this.overlayTarget.classList.add("hidden")
    }
  }

  toggleMenu() {
    if (this.actionsOpen) {
      this.closeActions()
    }

    const isOpen = this.menuTarget.classList.contains("translate-y-0")
    if (isOpen) {
      this.closeMenu()
    } else {
      this.overlayTarget.classList.remove("hidden")
      this.menuTarget.classList.remove("translate-y-full")
      this.menuTarget.classList.add("translate-y-0")
      this.menuButtonTarget.classList.remove("text-base-content/60")
      this.menuButtonTarget.classList.add("text-primary")
      this.menuIconTarget.classList.add("hidden")
      this.menuCloseIconTarget.classList.remove("hidden")
    }
  }

  closeAll() {
    this.closeActions()
    this.closeMenu()
  }

  closeMenu() {
    this.menuTarget.classList.remove("translate-y-0")
    this.menuTarget.classList.add("translate-y-full")
    this.menuButtonTarget.classList.remove("text-primary")
    this.menuButtonTarget.classList.add("text-base-content/60")
    this.menuIconTarget.classList.remove("hidden")
    this.menuCloseIconTarget.classList.add("hidden")

    if (!this.actionsOpen) {
      this.overlayTarget.classList.add("hidden")
    }
  }
}
