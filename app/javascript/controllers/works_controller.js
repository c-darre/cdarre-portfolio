import { Controller } from "@hotwired/stimulus"

// Survol d'une ligne Travaux → affiche le calque image correspondant.
// Sortie → retour au calque "base". object-fit:cover côté CSS : aucune
// contrainte de dimensions sur les images.
export default class extends Controller {
  connect() { this.show("base") }

  // data-action câblé ci-dessous via mouseenter/leave sur les lignes.
  hover(event) {
    const name = event.currentTarget.dataset.worksHover
    if (name) this.show(name)
  }
  reset() { this.show("base") }

  show(name) {
    this.element.querySelectorAll("[data-works-layer]").forEach((layer) => {
      layer.classList.toggle("is-shown", layer.dataset.worksLayer === name)
    })
  }
}
