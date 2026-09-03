# cdarre.fr — Portfolio

Portfolio personnel de **Cyprien Darré**, designer produit et développeur web.
Application Ruby on Rails, conçue, développée et déployée de bout en bout.

**En ligne : [cdarre.fr](https://cdarre.fr)**

---

## Ce que fait le site

Quatre espaces publics, tous administrables :

| Page | Rôle |
|---|---|
| `/` | Accueil — vidéo d'introduction, profil, index des travaux, galerie, contact |
| `/travaux` | Aiguillage entre les études de cas et la galerie |
| `/projets` | Index des études de cas, puis chaque étude en détail |
| `/galerie` | Fil de créations visuelles, en maçonnerie |
| `/a-propos` | Parcours, compétences, CV |

Un back-office (`/admin`) permet de créer et publier les études de cas — texte
riche, images, vidéos, documents PDF — ainsi que les visuels de la galerie.
Aucun contenu n'est écrit en dur dans le code.

## Parti pris technique

**Rails « à l'ancienne », rendu côté serveur.** Pas de framework front séparé :
Hotwire (Turbo + Stimulus) suffit à tout ce que fait le site, et le rendu au
premier octet vaut mieux qu'une page qui se remplit après coup — un portfolio
se doit d'être rapide, y compris sur un réseau mobile médiocre.

**Dix contrôleurs Stimulus** portent l'interactivité : défilement horizontal
asservi au scroll vertical, révélation d'images au curseur, visionneuse de
document paginée, agrandissement, sommaire actif, filtres, réordonnancement en
back-office.

**Images responsives.** Chaque visuel est servi à la taille réellement
affichée, en WebP, par variantes Active Storage et `srcset`. Mesuré avant
correction : les images étaient quatre à six fois trop grandes sur mobile,
densité Retina comprise.

**Typographie mesurée, pas approximée.** Les corps, les graisses et les
largeurs de colonne sont calés sur les métriques réelles des fontes (hauteur
d'œil, chasse), pas au jugé. La police d'accent est une instance figée de
Bricolage Grotesque, sous-ensemblée au latin.

**Aucune dépendance de suivi.** Ni régie, ni mesure d'audience tierce.

## Stack

- **Ruby 3.3.5** · **Rails 8.1**
- **PostgreSQL** — base principale, plus trois bases dédiées à Solid Cache,
  Solid Queue et Solid Cable
- **Hotwire** (Turbo, Stimulus) · **Importmap** — aucun bundler JavaScript
- **Propshaft** · **Dart Sass** — feuilles de style compilées, sans framework
  CSS au-delà de quelques utilitaires
- **Active Storage** + **libvips** — images et variantes
- **Devise** — accès au back-office
- **Kamal** + **Docker** — déploiement
- **Brakeman**, **RuboCop**, **bundler-audit** — vérifications en intégration
  continue

## Installation

Prérequis : Ruby 3.3.5, PostgreSQL, libvips (`brew install vips` sur macOS —
sans lui, les images sont servies en pleine résolution au lieu d'être
redimensionnées).

```bash
git clone https://github.com/c-darre/cdarre-portfolio.git
cd cdarre-portfolio

bin/setup          # dépendances, base, préparation
bin/dev            # serveur + compilation des styles en continu
```

Le site répond sur `http://localhost:3000`.

Pour créer un accès au back-office :

```bash
bin/rails runner 'AdminUser.create!(email: "vous@exemple.fr", password: "motdepasse")'
```

## Développement

```bash
bin/dev                    # serveur Rails + surveillance des styles
bin/rails dartsass:build   # compiler les styles une fois
bin/rubocop                # style de code
bin/brakeman               # analyse de sécurité
bin/ci                     # la chaîne complète
```

Un utilitaire maison convertit les GIF en MP4 — un GIF de logo est passé de
12 Mo à 214 Ko, pour un rendu meilleur :

```bash
bin/gif2mp4 chemin/vers/le/dossier
```

### Conventions de nommage des fichiers

Dans une section d'étude de cas, **le nom du fichier pilote son affichage** :

| Nom | Effet |
|---|---|
| `01-…`, `02-…` | ordre d'apparition |
| `…-grand.png` | visuel agrandi |
| `…-plein.png` | pleine largeur de la colonne de texte |
| `…-doc.png` | page envoyée dans la visionneuse paginée |

Active Storage n'ayant pas de champ de position, cette convention évite une
table de jointure et un glisser-déposer pour un besoin que le nom de fichier
règle très bien.

## Déploiement

Déploiement par **Kamal** sur un serveur privé, image hébergée sur GitHub
Container Registry, certificat TLS automatique.

```bash
git push origin main
bin/kamal deploy
```

La configuration se trouve dans `config/deploy.yml`. Les migrations sont
exécutées automatiquement à chaque déploiement.

À noter : le déploiement transporte le **code**, jamais les **données**. Le
contenu saisi en local reste en local ; celui de production se saisit depuis
le back-office en ligne.

## Structure

```
app/
├── controllers/        pages publiques + admin/
├── javascript/
│   └── controllers/    10 contrôleurs Stimulus
├── models/             CaseStudy, VisualWork, Award, ContactMessage
├── views/
│   ├── pages/          accueil, travaux, à propos, contact
│   ├── case_studies/   index et étude détaillée
│   ├── visual_works/   fil de la galerie
│   └── admin/          back-office
└── assets/
    ├── stylesheets/    Sass, un fichier par écran
    └── fonts/          Inter, IBM Plex Mono, Bricolage Grotesque
```

---

© 2026 Cyprien Darré. Le code est consultable à titre d'exemple ; les contenus,
textes et visuels ne sont pas réutilisables.
