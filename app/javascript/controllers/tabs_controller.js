import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  static classes = {
    activeTab: "text-primary font-semibold border-primary",
    inactiveTab: "text-base-content/60 font-medium border-transparent"
  }

  switch(event) {
    const index = this.tabTargets.indexOf(event.currentTarget)

    this.tabTargets.forEach((tab, i) => {
      if (i === index) {
        tab.classList.remove("text-base-content/60", "font-medium", "border-transparent")
        tab.classList.add("text-primary", "font-semibold", "border-primary")
      } else {
        tab.classList.remove("text-primary", "font-semibold", "border-primary")
        tab.classList.add("text-base-content/60", "font-medium", "border-transparent")
      }
    })

    this.panelTargets.forEach((panel, i) => {
      panel.classList.toggle("hidden", i !== index)
    })
  }
}
