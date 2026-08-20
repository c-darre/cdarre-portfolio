class VisualWork < ApplicationRecord
  has_many_attached :images

  scope :published, -> { where(published: true) }

  # FEED : ordre tire au sort a CHAQUE affichage, pour donner l'illusion d'un
  # fil vivant. Le tirage est demande a la base (ORDER BY RANDOM()) plutot que
  # de tout charger pour melanger ensuite.
  scope :feed, -> { order(Arel.sql("RANDOM()")) }

  # Le titre reste utile au back-office et a l'attribut alt, mais il n'est
  # plus obligatoire : un visuel peut vivre sans rien.
  def display_title
    title.presence || "Création visuelle"
  end

end
