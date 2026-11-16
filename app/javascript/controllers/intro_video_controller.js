import { Controller } from "@hotwired/stimulus"

// UNE SEULE balise video dans le DOM, dont la source est posee ici.
//
// Garder deux balises, l'une masquee par `display: none`, ne marche pas :
// `display: none` masque l'affichage mais n'empeche pas le telechargement.
// Sur mobile les deux fichiers partaient, 2,2 Mo dont 1,9 inutile.
//
// Trois precautions, toutes imposees par Safari iOS :
//
// 1. `load()` apres avoir pose `src`. Sans lui la source changee n'est pas
//    appliquee et l'element reste en attente indefiniment.
// 2. `play()` appele a la main. Safari iOS n'honore pas `autoplay` dans tous
//    les cas, en particulier quand la source arrive apres le chargement de
//    la page, et ne telecharge rien tant que la lecture n'est pas demandee.
// 3. Une relance au premier contact. Un refus de lecture reste possible, en
//    economie d'energie notamment ; l'image d'attente couvre l'ecran en
//    attendant, et le premier geste de l'utilisateur relance.
export default class extends Controller {
  static values = { paysage: String, portrait: String }

  connect() {
    const portrait = window.matchMedia("(max-aspect-ratio: 1 / 1)").matches
    const source = portrait ? this.portraitValue : this.paysageValue
    if (!source) return

    this.relance = () => this.joue()

    this.element.src = source
    this.element.load()

    // La lecture est demandee deux fois : tout de suite, et des que la
    // premiere image est la. La premiere suffit le plus souvent ; la seconde
    // rattrape les cas ou l'element n'etait pas encore pret.
    this.element.addEventListener("loadeddata", this.relance, { once: true })
    this.joue()
  }

  joue() {
    const lecture = this.element.play()
    if (!lecture) return

    lecture.catch(() => {
      document.addEventListener("touchstart", this.relance, { once: true, passive: true })
      document.addEventListener("click", this.relance, { once: true })
    })
  }

  disconnect() {
    document.removeEventListener("touchstart", this.relance)
    document.removeEventListener("click", this.relance)
  }
}
