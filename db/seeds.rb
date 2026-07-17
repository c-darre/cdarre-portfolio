# Seeds idempotentes : relançables sans doublons.

admin = AdminUser.find_or_initialize_by(email: "admin@cdarre.fr")
if admin.new_record?
  admin.password = "change-me-immediatement!"
  admin.save!
  puts "AdminUser créé : admin@cdarre.fr (CHANGE LE MOT DE PASSE)"
end

def build_sections(case_study, sections)
  sections.each_with_index do |(type, heading, html), i|
    section = case_study.case_study_sections.find_or_initialize_by(section_type: type)
    section.heading  = heading
    section.position = i
    section.body     = html
    section.save!
  end
end

# --- 1. FIB__R ---
fibr = CaseStudy.find_or_initialize_by(slug: "fibr")
fibr.assign_attributes(
  categories: "Full-stack, IA appliquée",
  title:      "FIB__R",
  subtitle:   "Éco-score textile : l'impact d'un vêtement à partir d'une photo",
  role:       "Idéateur & Lead Developer",
  context:    "Projet final Le Wagon (2026) : application full-stack Ruby on Rails, " \
              "IA Vision, API publique Ecobalyse, déployée et pitchée en direct.",
  key_metric: "De la photo au score : un parcours en 3 écrans",
  position:   0,
  published:  true
)
fibr.save!
build_sections(fibr, [
  [ "probleme",    "Problème",    "<p>[À rédiger : le constat utilisateur et le manque adressé.]</p>" ],
  [ "contraintes", "Contraintes", "<p>[À rédiger : délai bootcamp, périmètre API Ecobalyse, données.]</p>" ],
  [ "demarche",    "Démarche",    "<p>[À rédiger : de l'idée au scope, arbitrages produit.]</p>" ],
  [ "design",      "Design",      "<p>[À rédiger : parcours, UI, décisions d'interface.]</p>" ],
  [ "technique",   "Technique",   "<p>[À rédiger : IA Vision, schéma relationnel, intégration Ecobalyse.]</p>" ],
  [ "impact",      "Impact",      "<p>[À rédiger : déploiement, pitch, retours.]</p>" ],
  [ "reflexion",   "Réflexion",   "<p>[À rédiger : ce que je referais autrement.]</p>" ]
])

# --- 2. User Selfcare Portal ---
usp = CaseStudy.find_or_initialize_by(slug: "user-selfcare-portal")
usp.assign_attributes(
  categories: "Produit, Design System",
  title:      "User Selfcare Portal",
  subtitle:   "Refonte UX/UI d'un catalogue IT mondial",
  role:       "Lead UX/UI & UX Writing",
  context:    "Catalogue des produits et services IT d'un grand groupe automobile : " \
              "+100 000 utilisateurs dans 35 pays. Refonte avant/après, design system, " \
              "brief structuré aux équipes de développement.",
  key_metric: "+100 000 utilisateurs · 35 pays",
  position:   1,
  published:  false
)
usp.save!
build_sections(usp, [
  [ "probleme",    "Problème",    "<p>[À rédiger.]</p>" ],
  [ "contraintes", "Contraintes", "<p>[À rédiger : multi-pays, bilingue, ServiceNow, équipes distantes.]</p>" ],
  [ "demarche",    "Démarche",    "<p>[À rédiger.]</p>" ],
  [ "design",      "Design",      "<p>[À rédiger : design system, nommage, parcours restructurés.]</p>" ],
  [ "impact",      "Impact",      "<p>[À rédiger.]</p>" ],
  [ "reflexion",   "Réflexion",   "<p>[À rédiger.]</p>" ]
])

# --- 3. Clienteling (concept) ---
cli = CaseStudy.find_or_initialize_by(slug: "clienteling-concept")
cli.assign_attributes(
  categories: "Produit",
  title:      "Clienteling",
  subtitle:   "Concept d'outil vendeur retail haut de gamme",
  role:       "Product Designer (exploration personnelle)",
  context:    "Projet concept : conception d'un outil de clienteling. " \
              "Démarche complète présentée comme une exploration, sans client réel.",
  key_metric: "Projet concept : démarche documentée de bout en bout",
  position:   2,
  published:  false
)
cli.save!
build_sections(cli, [
  [ "probleme",    "Problème",    "<p>[À rédiger.]</p>" ],
  [ "contraintes", "Contraintes", "<p>[À rédiger : contraintes auto-imposées du concept.]</p>" ],
  [ "demarche",    "Démarche",    "<p>[À rédiger.]</p>" ],
  [ "design",      "Design",      "<p>[À rédiger.]</p>" ],
  [ "reflexion",   "Réflexion",   "<p>[À rédiger.]</p>" ]
])

# --- Award (conservé en base pour la future étude AITS, non affiché) ---
award = Award.find_or_initialize_by(year: 2021)
award.assign_attributes(
  title:       "1er Prix du meilleur site SharePoint public · Groupe Renault",
  description: "Portail interne AITS conçu et déployé de bout en bout : " \
               "architecture d'information, navigation, système graphique.",
  position:  0,
  published: true
)
award.save!

# --- Galerie : entrées d'exemple ---
[
  [ "Identité visuelle : [projet à nommer]", "identite" ],
  [ "Concept visuel : [projet à nommer]",    "concept" ],
  [ "Motion : affichage urbain",             "motion" ]
].each_with_index do |(title, cat), i|
  vw = VisualWork.find_or_initialize_by(title: title)
  vw.assign_attributes(category: cat, position: i, published: false,
                       description: "[Description courte à rédiger.]")
  vw.save!
end

puts "Seeds OK : #{CaseStudy.count} études, #{CaseStudySection.count} sections, " \
     "#{VisualWork.count} créations, #{Award.count} award."
