import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["title", "description", "button"]

  connect() {
    this.toggleButton()
    this.titleTarget.addEventListener("input", () => this.toggleButton())
    this.buttonTarget.addEventListener("click", () => this.generate())
  }

  toggleButton() {
    if (this.titleTarget.value.trim().length > 0) {
      this.buttonTarget.disabled = false
      this.buttonTarget.classList.remove("opacity-50", "cursor-not-allowed")
    } else {
      this.buttonTarget.disabled = true
      this.buttonTarget.classList.add("opacity-50", "cursor-not-allowed")
    }
  }

  async generate() {
    const title = this.titleTarget.value
    if (!title) return

    this.buttonTarget.disabled = true
    this.buttonTarget.classList.add("opacity-50", "cursor-not-allowed")
    try {
      const response = await fetch("/tasks/generate_description", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ title })
      })
      const data = await response.json()
      this.descriptionTarget.value = data.description
    } catch (e) {
      alert("Erro ao gerar descrição.")
    } finally {
      this.toggleButton()
    }
  }
} 