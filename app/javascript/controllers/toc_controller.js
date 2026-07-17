import { Controller } from "@hotwired/stimulus"

// Sommaire vertical : surligne l'entrée de la section actuellement à l'écran.
// IntersectionObserver natif, zéro dépendance. Le sommaire lui-même est
// rendu sticky en CSS ; ce contrôleur ne gère que l'état "actif".
export default class extends Controller {
  static targets = ["link"]

  connect() {
    this.observer = new IntersectionObserver(
      (entries) => this.onIntersect(entries),
      { rootMargin: "-45% 0px -45% 0px", threshold: 0 }  // bande centrale de l'écran
    )
    this.sections = this.linkTargets
      .map((l) => document.querySelector(l.getAttribute("href")))
      .filter(Boolean)
    this.sections.forEach((s) => this.observer.observe(s))
  }

  disconnect() { this.observer?.disconnect() }

  onIntersect(entries) {
    entries.forEach((entry) => {
      if (!entry.isIntersecting) return
      const id = `#${entry.target.id}`
      this.linkTargets.forEach((l) =>
        l.classList.toggle("is-active", l.getAttribute("href") === id)
      )
    })
  }
}
