import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "toggleButton", "toggleIcon", "form"]

  connect() {
    this.listTarget.style.display = "none"
    this.toggleIconTarget.style.transform = "rotate(0deg)"
  }

  toggle() {
    const isVisible = this.listTarget.style.display !== "none"
    this.listTarget.style.display = isVisible ? "none" : "block"
    
    this.toggleIconTarget.style.transform = isVisible ? "rotate(0deg)" : "rotate(180deg)"

    if (isVisible) {
      const form = this.listTarget.querySelector("form")
      if (form) form.reset()
    }
  }

  showList() {
    this.listTarget.style.display = "block"
    this.toggleIconTarget.style.transform = "rotate(180deg)"
  }

  resetForm(event) {
    if (event.detail.success) {
      this.formTarget.reset();
    }
  }
} 