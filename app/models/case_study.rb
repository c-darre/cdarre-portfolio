class CaseStudy < ApplicationRecord
  # Catégories canoniques — source unique (helper + pages y puisent).
  CATEGORIES = [ "Produit", "Design System", "Full-stack", "IA appliquée", "Stratégie de marque" ].freeze

  # DEUX visuels obligatoires : celui du repos et celui du survol, sur /projets.
  # Aucune migration : Active Storage stocke les pieces jointes a part.
  has_one_attached :hero_image
  has_one_attached :hover_image
  has_many :case_study_sections, -> { order(:position) },
           dependent: :destroy, inverse_of: :case_study

  before_validation :generate_slug

  validates :title, presence: true
  validates :slug,  presence: true, uniqueness: true
  validate  :categories_are_canonical
  # Contexte :admin uniquement - declenche par le formulaire du back-office.
  # Hors de ce contexte (seeds, toggle_published, console) l'enregistrement
  # reste possible sans visuel : les blocs gris prennent le relais a l'ecran.
  validate  :both_images_attached, on: :admin

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

  # Les deux visuels sont exiges : sans eux, la bascule au survol de /projets
  # n'a rien a montrer. `presence: true` ne convient pas sur une piece jointe
  # Active Storage (le proxy n'est jamais nil) - d'ou ce test explicite.
  def both_images_attached
    errors.add(:hero_image,  "est obligatoire (visuel au repos)") unless hero_image.attached?
    errors.add(:hover_image, "est obligatoire (visuel au survol)") unless hover_image.attached?
  end

  # N'accepte que les libellés canoniques : un tag hors-liste casserait le filtre.
  def categories_are_canonical
    invalid = category_list - CATEGORIES
    return if invalid.empty?

    errors.add(:categories, "catégorie(s) non reconnue(s) : #{invalid.join(', ')}. " \
                            "Valeurs autorisées : #{CATEGORIES.join(', ')}.")
  end
end
