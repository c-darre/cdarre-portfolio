import { Controller } from "@hotwired/stimulus"

// Dispersion des visuels d'arriere-plan de /projets.
//
// CONTRAINTE : deux visuels de rangees voisines ne doivent jamais se toucher
// par un BORD. Se toucher par un COIN est autorise — c'est meme le cas limite
// que produit un intervalle qui finit exactement ou le suivant commence.
//
// Pourquoi cote client, et pas un tirage au sort en Ruby : la largeur rendue
// d'un visuel vaut son format x la hauteur de rangee. Or cette hauteur est un
// clamp() de la HAUTEUR de fenetre, tandis que la largeur de rangee suit la
// LARGEUR de fenetre. Le rapport des deux change donc avec la forme de la
// fenetre (24 % de la rangee en 1440x900, 48 % en 1024x1200 pour un meme
// 16:10). Le serveur ne peut pas le savoir : on mesure, puis on place.
export default class extends Controller {
  static targets = ["media"]

  connect() {
    this.scatter = this.scatter.bind(this)
    this.replace = this.debounce(this.scatter, 150)

    window.addEventListener("resize", this.replace)

    // Une image peut arriver apres le premier calcul : on replace a l'arrivee.
    this.element.querySelectorAll("img").forEach((img) => {
      if (!img.complete) img.addEventListener("load", this.replace, { once: true })
    })

    // Le filtre par categorie masque des rangees : le voisinage change donc,
    // et la contrainte doit etre re-evaluee sur les rangees restantes.
    this.observer = new MutationObserver(this.replace)
    this.mediaTargets.forEach((m) => {
      const row = m.closest(".csi-row")
      if (row) this.observer.observe(row, { attributeFilter: ["hidden"] })
    })

    this.scatter()
  }

  disconnect() {
    window.removeEventListener("resize", this.replace)
    if (this.observer) this.observer.disconnect()
  }

  scatter() {
    // On mesure TOUT d'abord : le placement d'une rangee depend de la largeur
    // de la suivante (cf. pick), donc il faut connaitre la liste entiere.
    const visibles = []
    this.mediaTargets.forEach((media) => {
      const row = media.closest(".csi-row")
      if (!row || row.hidden) return          // masquee : hors voisinage

      const total = media.offsetWidth
      if (!total) return

      // Les deux calques partagent un axe : c'est le PLUS LARGE des deux qui
      // definit l'encombrement, sinon le survol deborderait sur le voisin.
      const largeurs = Array.from(media.querySelectorAll(".csi-layer"))
                            .map((l) => l.offsetWidth)
      if (!largeurs.length) return

      visibles.push({
        media: media,
        w: Math.min(Math.max.apply(null, largeurs) / total, 0.98)
      })
    })

    let prev = null   // intervalle [gauche, droite] de la rangee precedente
    visibles.forEach((item, i) => {
      const wSuivant = i + 1 < visibles.length ? visibles[i + 1].w : null
      const gauche = this.pick(item.w, prev, wSuivant)
      const droite = gauche + item.w
      prev = [gauche, droite]
      this.place(item.media, gauche, droite)
    })
  }

  // Deux contraintes se croisent :
  //   1. ne pas chevaucher la rangee du DESSUS (contrainte dure) ;
  //   2. laisser de quoi poser la rangee du DESSOUS (anticipation).
  // Sans le point 2, deux visuels larges d'affilee finissaient toujours par
  // se toucher : le premier se posait au milieu et bloquait le second.
  // Un intervalle qui FINIT exactement ou l'autre COMMENCE est accepte :
  // c'est le contact par le coin, autorise.
  pick(w, prev, wSuivant) {
    const span = 1 - w
    if (span <= 0) return 0

    let zones = []
    if (!prev) {
      zones = [[0, span]]
    } else {
      if (prev[0] - w >= 0) zones.push([0, prev[0] - w])
      if (prev[1] <= span) zones.push([prev[1], span])
    }

    if (wSuivant != null) {
      const pourSuivant = []
      if (1 - wSuivant - w >= 0) pourSuivant.push([0, 1 - wSuivant - w])
      if (wSuivant <= span) pourSuivant.push([wSuivant, span])

      const croise = []
      for (const a of zones) {
        for (const b of pourSuivant) {
          const lo = Math.max(a[0], b[0])
          const hi = Math.min(a[1], b[1])
          if (hi >= lo) croise.push([lo, hi])
        }
      }
      // Si l'anticipation ne laisse rien, on garde la contrainte dure seule.
      if (croise.length) zones = croise
    }

    if (!zones.length) {
      // Ne survient que si les deux visuels depassent CHACUN la moitie de la
      // rangee : leur somme excede la largeur disponible, aucune disposition
      // ne peut les separer. On les envoie aux bords opposes, ce qui reduit
      // le recouvrement au minimum geometriquement possible.
      return prev[0] + prev[1] < 1 ? span : 0
    }

    // Tirage pondere par la longueur : une grande zone est plus souvent
    // choisie qu'une petite, ce qui evite d'agglutiner les visuels sur un bord.
    const longueur = zones.reduce((s, z) => s + (z[1] - z[0]), 0)
    let t = Math.random() * longueur
    for (const z of zones) {
      if (t <= z[1] - z[0]) return z[0] + t
      t -= z[1] - z[0]
    }
    return zones[0][0]
  }

  // L'ancre suit la position finale : un visuel a gauche partage son bord
  // gauche, au centre son axe median, a droite son bord droit. C'est ce qui
  // empeche la bascule du survol de sauter quand les deux formats different.
  place(media, left, right) {
    const centre = (left + right) / 2
    media.classList.remove("csi-anchor-left", "csi-anchor-center", "csi-anchor-right")

    if (centre < 1 / 3) {
      media.classList.add("csi-anchor-left")
      media.style.setProperty("--x", (left * 100).toFixed(2) + "%")
    } else if (centre > 2 / 3) {
      media.classList.add("csi-anchor-right")
      media.style.setProperty("--x", ((1 - right) * 100).toFixed(2) + "%")
    } else {
      media.classList.add("csi-anchor-center")
      media.style.setProperty("--x", (centre * 100).toFixed(2) + "%")
    }
  }

  debounce(fn, ms) {
    let id
    return function () {
      clearTimeout(id)
      id = setTimeout(fn, ms)
    }
  }
}
