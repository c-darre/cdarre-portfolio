import { Controller } from "@hotwired/stimulus"

// Filtrage client instantané des études par catégorie.
// Chaque item porte data-filter-categories (liste séparée par "|").
// Aucun rechargement : on masque/affiche, la position de scroll est préservée.
export default class extends Controller {
  static targets = ["item", "chip"]

  filter(event) {
    const cat = event.currentTarget.dataset.filterCat  // "" = Toutes

    this.chipTargets.forEach((c) =>
      c.classList.toggle("is-active", c.dataset.filterCat === cat)
    )

    this.itemTargets.forEach((item) => {
      const cats = (item.dataset.filterCategories || "").split("|")
      const show = cat === "" || cats.includes(cat)
      item.hidden = !show
    })
  }
}
