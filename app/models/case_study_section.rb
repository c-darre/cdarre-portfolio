class CaseStudySection < ApplicationRecord
  belongs_to :case_study, inverse_of: :case_study_sections

  has_rich_text :body          # ActionText — corps narratif éditable via Trix
  has_many_attached :images    # visuels de la section (grands formats)

  # Enum string-backed : la base reste lisible en SQL brut ("design", pas 3).
  # prefix: :kind => méthodes kind_probleme?, kind_design?… (évite les collisions
  # avec des noms génériques comme "design" ou "impact").
  enum :section_type, {
    probleme:    "probleme",
    contraintes: "contraintes",
    demarche:    "demarche",
    design:      "design",
    technique:   "technique",
    impact:      "impact",
    reflexion:   "reflexion"
  }, prefix: :kind

  validates :section_type, presence: true
end
