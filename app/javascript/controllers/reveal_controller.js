import { Controller } from "@hotwired/stimulus"

// Portrait reactif a la position du curseur SUR TOUT L'ECRAN :
//   - curseur loin   -> flou maximal
//   - curseur proche -> le flou se resorbe progressivement
//   - curseur dessus -> parfaitement net
// S'y ajoute une parallaxe INVERSE : l'image derive a l'oppose du curseur.
// Amplitude mesuree sur la reference : ~6 px. C'est volontairement infime —
// l'effet doit se sentir, pas se voir.
export default class extends Controller {
  static FLOU_MAX = 18      // px, quand le curseur est au loin
  static PORTEE = 0.62      // fraction de la diagonale ou le flou sature
  static DERIVE = 7         // px, amplitude de la parallaxe inverse
  static SUIVI = 0.09       // inertie : plus bas = plus de traine

  connect() {
    // `data-flou` surcharge FLOU_MAX pour cet element seulement.
    const surcharge = parseFloat(this.element.dataset.flou)
    this.flouMax = Number.isFinite(surcharge) ? surcharge : this.constructor.FLOU_MAX

    this.cible = { flou: 1, dx: 0, dy: 0 }
    this.actuel = { flou: 1, dx: 0, dy: 0 }
    this.frame = null

    this.onMove = this.onMove.bind(this)
    this.boucle = this.boucle.bind(this)

    // Ecoute globale : c'est toute la fenetre qui pilote l'effet.
    window.addEventListener("pointermove", this.onMove, { passive: true })
    this.appliquer()
  }

  disconnect() {
    window.removeEventListener("pointermove", this.onMove)
    if (this.frame) cancelAnimationFrame(this.frame)
  }

  onMove(event) {
    if (event.pointerType === "touch") return
    const r = this.element.getBoundingClientRect()
    if (!r.width) return

    // Distance au BORD du cadre (et non au centre) : le flou tombe a zero
    // des que le curseur entre sur la photo, pas seulement en son milieu.
    const ecartX = Math.max(r.left - event.clientX, 0, event.clientX - r.right)
    const ecartY = Math.max(r.top - event.clientY, 0, event.clientY - r.bottom)
    const distance = Math.hypot(ecartX, ecartY)

    const diagonale = Math.hypot(window.innerWidth, window.innerHeight)
    this.cible.flou = Math.min(distance / (diagonale * this.constructor.PORTEE), 1)

    const cx = r.left + r.width / 2
    const cy = r.top + r.height / 2
    this.cible.dx = -clamp((event.clientX - cx) / (window.innerWidth / 2), -1, 1)
    this.cible.dy = -clamp((event.clientY - cy) / (window.innerHeight / 2), -1, 1)

    this.demarrer()
  }

  demarrer() { if (!this.frame) this.frame = requestAnimationFrame(this.boucle) }

  boucle() {
    const C = this.constructor
    const a = this.actuel, c = this.cible
    a.flou += (c.flou - a.flou) * C.SUIVI
    a.dx += (c.dx - a.dx) * C.SUIVI
    a.dy += (c.dy - a.dy) * C.SUIVI
    this.appliquer()

    const fini = Math.abs(c.flou - a.flou) < 0.002 &&
                 Math.abs(c.dx - a.dx) < 0.002 &&
                 Math.abs(c.dy - a.dy) < 0.002
    this.frame = fini ? null : requestAnimationFrame(this.boucle)
  }

  appliquer() {
    const C = this.constructor
    const { flou, dx, dy } = this.actuel
    this.element.style.setProperty("--flou", `${(flou * this.flouMax).toFixed(2)}px`)
    this.element.style.setProperty("--dx", `${(dx * C.DERIVE).toFixed(2)}px`)
    this.element.style.setProperty("--dy", `${(dy * C.DERIVE).toFixed(2)}px`)
  }
}

function clamp(v, min, max) { return Math.min(Math.max(v, min), max) }
