class VisualWork < ApplicationRecord
  has_many_attached :images

  enum :category, {
    identite: "identite",
    concept:  "concept",
    motion:   "motion",
    autre:    "autre"
  }, prefix: true

  validates :title, presence: true

  scope :published, -> { where(published: true) }
  scope :ordered,   -> { order(:position) }
end
