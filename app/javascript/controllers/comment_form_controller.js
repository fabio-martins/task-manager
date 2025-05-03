import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "toggleButton", "toggleIcon", "form"]

  connect() {
    // Hide comments list by default
    this.listTarget.style.display = "none"
    // Set initial rotation for the icon
    this.toggleIconTarget.style.transform = "rotate(0deg)"
  }

  toggle() {
    const isVisible = this.listTarget.style.display !== "none"
    this.listTarget.style.display = isVisible ? "none" : "block"
    
    // Rotate chevron icon
    this.toggleIconTarget.style.transform = isVisible ? "rotate(0deg)" : "rotate(180deg)"

    // Clear comment form if closing
    if (isVisible) {
      const form = this.listTarget.querySelector("form")
      if (form) form.reset()
    }
  }

  // Show comments list after adding a comment
  showList() {
    this.listTarget.style.display = "block"
    this.toggleIconTarget.style.transform = "rotate(180deg)"
  }

  resetForm(event) {
    // Só limpa se não houver erro de validação
    if (event.detail.success) {
      this.formTarget.reset();
    }
  }
} 