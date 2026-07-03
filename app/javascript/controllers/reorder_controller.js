import { Controller } from "@hotwired/stimulus"
import Sortable from "sortablejs"

// Réordonnancement par glisser-déposer.
// - data-reorder-url-value : l'URL PATCH cible (diffère selon la ressource)
// - chaque ligne déplaçable porte data-id="<id>"
// - la saisie se fait via une poignée [data-reorder-handle]
export default class extends Controller {
  static values = { url: String }

  connect() {
    this.sortable = Sortable.create(this.element, {
      animation: 150,
      handle: "[data-reorder-handle]",
      onEnd: () => this.persist()
    })
  }

  disconnect() {
    this.sortable?.destroy()
  }

  persist() {
    const ids = Array.from(this.element.querySelectorAll("[data-id]"))
                     .map((el) => el.dataset.id)

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ ids })
    })
  }
}
