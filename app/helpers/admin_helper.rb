module AdminHelper
  # Libellés FR des types de section. Les clés machine viennent de l'enum du modèle.
  SECTION_TYPE_LABELS = {
    "probleme"    => "Problème",
    "contraintes" => "Contraintes",
    "demarche"    => "Démarche",
    "design"      => "Design",
    "technique"   => "Technique",
    "impact"      => "Impact",
    "reflexion"   => "Réflexion"
  }.freeze

  CATEGORY_LABELS = {
    "identite" => "Identité visuelle",
    "concept"  => "Concept",
    "motion"   => "Motion",
    "autre"    => "Autre"
  }.freeze

  def section_type_label(key)
    SECTION_TYPE_LABELS.fetch(key.to_s, key.to_s.humanize)
  end

  # Paires [libellé, valeur] prêtes pour un <select>.
  def section_type_options
    SECTION_TYPE_LABELS.map { |value, label| [ label, value ] }
  end

  def category_label(key)
    CATEGORY_LABELS.fetch(key.to_s, key.to_s.humanize)
  end

  def category_options
    CATEGORY_LABELS.map { |value, label| [ label, value ] }
  end
end
