class CaseStudy < ApplicationRecord
  # Catégories canoniques — source unique (helper + pages y puisent).
  CATEGORIES = [ "Produit", "Design System", "Full-stack", "IA appliquée" ].freeze

  has_one_attached :hero_image
  has_many :case_study_sections, -> { order(:position) },
           dependent: :destroy, inverse_of: :case_study

  before_validation :generate_slug

  validates :title, presence: true
  validates :slug,  presence: true, uniqueness: true
  validate  :categories_are_canonical

  scope :published, -> { where(published: true) }
  scope :ordered,   -> { order(:position) }

  def to_param = slug

  # "Full-stack, IA appliquée" -> ["Full-stack", "IA appliquée"]
  def category_list
    categories.to_s.split(",").map(&:strip).reject(&:blank?)
  end

  private

  def generate_slug
    self.slug = title.to_s.parameterize if slug.blank? && title.present?
  end

  # N'accepte que les libellés canoniques : un tag hors-liste casserait le filtre.
  def categories_are_canonical
    invalid = category_list - CATEGORIES
    return if invalid.empty?

    errors.add(:categories, "catégorie(s) non reconnue(s) : #{invalid.join(', ')}. " \
                            "Valeurs autorisées : #{CATEGORIES.join(', ')}.")
  end
end
