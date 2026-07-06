import { Controller } from "@hotwired/stimulus"

// Lightbox minimale sur <dialog> natif.
// Le navigateur fournit : focus piégé dans la modale, fermeture Échap, ::backdrop.
// Nous : injecter l'image cliquée, gérer le clic hors image, fermer avant cache Turbo.
export default class extends Controller {
  static targets = ["dialog", "image"]

  open(event) {
    const { src, alt } = event.currentTarget.dataset
    this.imageTarget.src = src
    this.imageTarget.alt = alt || ""
    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  // Un clic sur le backdrop cible le <dialog> lui-même (pas ses enfants).
  backdropClose(event) {
    if (event.target === this.dialogTarget) this.close()
  }

  // Turbo met la page en cache à la navigation : on ne fige jamais un dialog ouvert.
  disconnect() {
    if (this.hasDialogTarget && this.dialogTarget.open) this.dialogTarget.close()
  }
}
