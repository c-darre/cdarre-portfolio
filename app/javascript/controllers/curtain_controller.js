import { Controller } from "@hotwired/stimulus"

// Rideau pour une section PLUS HAUTE qu'un écran.
// Le pattern CSS .screen (sticky top) ne vaut que pour des sections d'un
// écran : au-delà, le bas devient inatteignable (cf. bug galerie). Ici la
// section s'épingle seulement quand son BAS atteint le bas du viewport —
// tout le contenu a donc déjà défilé — puis la suivante glisse par-dessus.
export default class extends Controller {
  connect() {
    this.media = window.matchMedia("(min-width: 961px) and (prefers-reduced-motion: no-preference)")
    this.refresh = this.refresh.bind(this)
    this.observer = new ResizeObserver(this.refresh)
    this.observer.observe(this.element)
    window.addEventListener("resize", this.refresh)
    this.refresh()
  }

  disconnect() {
    this.observer?.disconnect()
    window.removeEventListener("resize", this.refresh)
    this.reset()
  }

  refresh() {
    if (!this.media.matches) return this.reset()

    const overflow = this.element.offsetHeight - window.innerHeight
    if (overflow <= 0) return this.reset()   // tient dans l'écran : rien à faire

    this.element.style.position = "sticky"
    this.element.style.top = `-${overflow}px`
  }

  reset() {
    this.element.style.position = ""
    this.element.style.top = ""
  }
}
