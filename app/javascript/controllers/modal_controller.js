import { Controller } from "@hotwired/stimulus"

// Popup générique sur <dialog> natif (focus piégé, Échap, ::backdrop fournis par le navigateur).
export default class extends Controller {
  static targets = ["dialog"]

  open() { this.dialogTarget.showModal() }
  close() { this.dialogTarget.close() }

  // Un clic sur le backdrop cible le <dialog> lui-même (pas ses enfants).
  backdropClose(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  // Ne jamais figer un dialog ouvert dans le cache Turbo.
  disconnect() {
    if (this.hasDialogTarget && this.dialogTarget.open) this.dialogTarget.close()
  }
}
