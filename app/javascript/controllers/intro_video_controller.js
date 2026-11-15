import { Controller } from "@hotwired/stimulus"

// UNE SEULE balise video dans le DOM, dont la source est posee ici.
//
// Le montage precedent en gardait deux, l'une masquee par `display: none`.
// Or `display: none` n'empeche PAS le telechargement d'une video : il ne
// masque que l'affichage. Tant que `preload` valait `none`, rien ne partait
// et l'arrangement tenait ; mais `preload="none"` empechait aussi le
// demarrage automatique sur Safari iOS, qui attend alors une demande de
// lecture que personne ne peut faire, les controles etant retires.
//
// En posant la source apres mesure de l'orientation, un seul fichier part :
// 332 Ko en portrait, 1,9 Mo en paysage. L'image d'attente, elle, est un
// fond CSS, donc visible des la premiere peinture, avant meme ce script.
export default class extends Controller {
  static values = { paysage: String, portrait: String }

  connect() {
    const portrait = window.matchMedia("(max-aspect-ratio: 1 / 1)").matches
    const source = portrait ? this.portraitValue : this.paysageValue
    if (!source) return

    this.element.src = source
    // Safari iOS ne lance pas toujours la lecture sur la seule presence de
    // `autoplay` quand la source arrive apres coup. Un refus est sans
    // consequence : le fond CSS reste affiche.
    this.element.play().catch(() => {})
  }
}
