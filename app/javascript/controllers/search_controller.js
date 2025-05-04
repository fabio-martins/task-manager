import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list"]

  connect() {
    // Debounce the search to avoid too many requests
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.performSearch()
    }, 300) // Wait 300ms after last keystroke before searching
  }

  submit(event) {
    event.preventDefault()
    clearTimeout(this.timeout)
    this.performSearch()
  }

  performSearch() {
    const query = this.inputTarget.value
    const url = `/tasks?search=${encodeURIComponent(query)}`
    
    fetch(url, {
      headers: {
        "Accept": "text/vnd.turbo-stream.html",
        "Turbo-Frame": "tasks_list"
      }
    })
    .then(response => response.text())
    .then(html => {
      Turbo.renderStreamMessage(html)
    })
  }
} 