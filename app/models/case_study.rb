class CaseStudy < ApplicationRecord
  has_one_attached :hero_image
  has_many :case_study_sections, -> { order(:position) },
           dependent: :destroy, inverse_of: :case_study

  before_validation :generate_slug

  validates :title, presence: true
  validates :slug,  presence: true, uniqueness: true

  # Scopes EXPLICITES (pas de default_scope : comportement implicite = dette).
  scope :published, -> { where(published: true) }
  scope :ordered,   -> { order(:position) }

  # Les URLs publiques utilisent le slug (/projets/fibr), pas l'id.
  def to_param = slug

  private

  # Slug auto depuis le titre, seulement s'il est vide : une fois publié
  # (et indexé par Google), le slug ne bouge plus même si le titre change.
  def generate_slug
    self.slug = title.to_s.parameterize if slug.blank? && title.present?
  end
end
