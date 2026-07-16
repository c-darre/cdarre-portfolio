import { Controller } from "@hotwired/stimulus"

// Galerie horizontale pilotée par le défilement VERTICAL natif.
// Fini l'interception de molette (bug dépendant du curseur) : la section
// devient un couloir vertical (hauteur = un écran + distance horizontale),
// un viewport interne s'y épingle, et la position verticale est TRADUITE
// en position horizontale, pixel pour pixel.
// → le pin n'engage que section alignée (plus de demi-sections),
// → impossible de passer à la suite sans avoir tout parcouru,
// → molette, trackpad, clavier, barre de défilement : tout fonctionne.
export default class extends Controller {
  static targets = ["pin", "track"]

  connect() {
    this.media = window.matchMedia("(min-width: 961px) and (prefers-reduced-motion: no-preference)")
    this.onScroll = this.onScroll.bind(this)
    this.measure = this.measure.bind(this)
    this.observer = new ResizeObserver(this.measure)
    this.observer.observe(this.trackTarget)
    window.addEventListener("scroll", this.onScroll, { passive: true })
    window.addEventListener("resize", this.measure)
    this.measure()
  }

  disconnect() {
    this.observer?.disconnect()
    window.removeEventListener("scroll", this.onScroll)
    window.removeEventListener("resize", this.measure)
    this.element.style.height = ""
  }

  measure() {
    if (!this.media.matches) { this.element.style.height = ""; return }

    const track = this.trackTarget
    this.distance = Math.max(0, track.scrollWidth - track.clientWidth)
    // Couloir = hauteur du viewport épinglé + distance horizontale à traduire.
    this.element.style.height = `${this.pinTarget.offsetHeight + this.distance}px`
    this.onScroll()
  }

  onScroll() {
    if (!this.media.matches || !this.distance) return

    const stickyTop = parseFloat(getComputedStyle(this.pinTarget).top) || 0
    const progress = Math.min(1, Math.max(0,
      (stickyTop - this.element.getBoundingClientRect().top) / this.distance
    ))
    this.trackTarget.scrollLeft = progress * this.distance
  }

  // Flèches : sur desktop on déplace la PAGE (la traduction fait le reste) ;
  // sur mobile, la piste directement (balayage natif par ailleurs).
  next() { this.step(1) }
  prev() { this.step(-1) }

  step(dir) {
    const card = this.trackTarget.querySelector("[data-hscroll-card]")
    const amount = card ? card.getBoundingClientRect().width + 24 : this.trackTarget.clientWidth * 0.6
    if (this.media.matches) {
      window.scrollBy({ top: dir * amount, behavior: "smooth" })
    } else {
      this.trackTarget.scrollBy({ left: dir * amount, behavior: "smooth" })
    }
  }
}
