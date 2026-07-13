class VisualWork < ApplicationRecord
  has_many_attached :images

  enum :category, {
    identite: "identite",
    concept:  "concept",
    motion:   "motion",
    autre:    "autre"
  }, prefix: true

  validates :title, presence: true
  validate  :tools_count_within_limit

  scope :published, -> { where(published: true) }
  scope :ordered,   -> { order(:position) }

  # "Figma, Illustrator, After Effects" -> ["Figma", "Illustrator", "After Effects"]
  def tools_list
    tools.to_s.split(",").map(&:strip).reject(&:blank?).first(4)
  end

  private

  # Contrainte d'espace des cards (directive : 4 maximum).
  def tools_count_within_limit
    return if tools.to_s.split(",").map(&:strip).reject(&:blank?).size <= 4

    errors.add(:tools, "4 outils maximum (séparés par des virgules)")
  end
end
