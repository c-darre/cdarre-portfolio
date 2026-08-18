import { Controller } from "@hotwired/stimulus"

// Visionneuse page a page. Une seule page est visible a la fois ; les autres
// restent dans le DOM mais masquees, ce qui evite un rechargement a chaque
// tour de page (les images sont en `lazy`, donc rien n'est telecharge avant
// d'etre demande).
export default class extends Controller {
  static targets = ["page", "compteur", "prev", "next"]

  connect() {
    this.index = 0
    this.afficher()
    this.onKey = this.onKey.bind(this)
    this.element.addEventListener("keydown", this.onKey)
  }

  disconnect() { this.element.removeEventListener("keydown", this.onKey) }

  onKey(event) {
    if (event.key === "ArrowLeft") { this.prev(); event.preventDefault() }
    if (event.key === "ArrowRight") { this.next(); event.preventDefault() }
  }

  prev() { if (this.index > 0) { this.index--; this.afficher() } }
  next() { if (this.index < this.pageTargets.length - 1) { this.index++; this.afficher() } }

  afficher() {
    const total = this.pageTargets.length
    this.pageTargets.forEach((page, i) => {
      page.hidden = i !== this.index
      // Charge la page suivante a l'avance : le tour de page parait instantane.
      if (i === this.index + 1) page.loading = "eager"
    })
    if (this.hasCompteurTarget) {
      this.compteurTarget.textContent = `${this.index + 1} / ${total}`
    }
    if (this.hasPrevTarget) this.prevTarget.disabled = this.index === 0
    if (this.hasNextTarget) this.nextTarget.disabled = this.index === total - 1
  }
}
