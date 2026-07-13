import { Controller } from "@hotwired/stimulus"

// Galerie horizontale : la molette verticale défile horizontalement
// tant qu'il reste du contenu ; en butée, on REND LA MAIN au scroll
// vertical de la page (jamais de piège). Tactile : natif. Flèches : boutons.
export default class extends Controller {
  static targets = ["track"]

  wheel(event) {
    const track = this.trackTarget
    const delta = Math.abs(event.deltaY) > Math.abs(event.deltaX) ? event.deltaY : event.deltaX
    const atStart = track.scrollLeft <= 0
    const atEnd   = track.scrollLeft + track.clientWidth >= track.scrollWidth - 1

    // En butée dans le sens demandé : laisser la page défiler normalement.
    if ((delta > 0 && atEnd) || (delta < 0 && atStart)) return

    event.preventDefault()
    track.scrollLeft += delta
  }

  next()  { this.step(1) }
  prev()  { this.step(-1) }

  step(dir) {
    const track = this.trackTarget
    const card = track.querySelector("[data-hscroll-card]")
    const amount = card ? card.getBoundingClientRect().width + 24 : track.clientWidth * 0.6
    track.scrollBy({ left: dir * amount, behavior: "smooth" })
  }
}
