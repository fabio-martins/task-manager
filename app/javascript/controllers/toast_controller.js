import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["toast"];

  connect() {
    this.showToast();
  }

  showToast() {
    setTimeout(() => {
      this.toastTarget.classList.add("opacity-0");
      this.toastTarget.classList.remove("opacity-100");
      this.toastTarget.addEventListener('transitionend', () => {
        this.toastTarget.remove(); // Remove o toast do DOM depois que ele desaparecer
      });
    }, 3000); // O toast desaparece após 3 segundos
  }
}
