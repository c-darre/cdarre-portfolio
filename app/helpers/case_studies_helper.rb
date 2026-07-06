module CaseStudiesHelper
  # Encart « double lecture » : la même étude, deux angles d'entrée.
  DESIGN_TYPES  = %w[demarche design technique].freeze
  PRODUCT_TYPES = %w[probleme contraintes impact reflexion].freeze

  # => { "Lecture design" => [sections...], "Lecture produit" => [sections...] }
  # Les colonnes vides sont retirées (étude sans section technique, par ex.).
  def reading_paths(sections)
    {
      "Lecture design"  => sections.select { |s| DESIGN_TYPES.include?(s.section_type) },
      "Lecture produit" => sections.select { |s| PRODUCT_TYPES.include?(s.section_type) }
    }.reject { |_label, list| list.empty? }
  end
end
