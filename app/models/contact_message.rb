class ContactMessage < ApplicationRecord
  URL_PATTERN = %r{https?://|www\.|\b[a-z0-9-]+\.(?:com|net|ru|top|xyz|do|gd|link|club|online|site)\b}i
  SEUIL = 3

  validates :name,  presence: true, length: { maximum: 120 }
  validates :email, presence: true, length: { maximum: 200 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body,  presence: true, length: { maximum: 5000 }

  scope :legitimes,    -> { where(spam: false) }
  scope :indesirables, -> { where(spam: true) }

  # Score d'indesirabilite. Le temps de remplissage pese le plus lourd.
  def self.spam_score(name:, email:, body:, secondes:)
    score = 0
    score += 3 if secondes.nil?
    score += 3 if secondes && secondes < 3
    score += 1 if secondes && secondes > 43_200

    liens = body.to_s.scan(URL_PATTERN).size
    score += 2 if liens >= 1
    score += 2 if liens >= 2

    local = email.to_s.split("@").first.to_s.downcase.gsub(/[^a-z]/, "")
    jeton = name.to_s.downcase.gsub(/[^a-z]/, "")
    score += 1 if !name.to_s.strip.include?(" ") && jeton.present? && !local.include?(jeton[0, 4].to_s)

    latin = body.to_s.count("A-Za-zÀ-ÿ")
    score += 1 if body.to_s.length > 20 && latin < body.to_s.length * 0.5

    # Ajouts du 24/09/2026, apres le passage d'un message de test automatise
    # sans lien, sans caractere non latin et avec un temps de remplissage
    # plausible : les criteres precedents lui donnaient 1.

    # Un corps de plus de 20 caracteres sans le moindre espace n'est pas une
    # phrase, c'est une chaine de test. Signal le plus fort du lot.
    score += 3 if body.to_s.length > 20 && !body.to_s.include?(" ")

    # Un nom de personne ne porte pas de chiffres.
    score += 1 if name.to_s.match?(/\d/)

    # Cinq consonnes d'affilee : aucun mot francais ni anglais n'en produit.
    suite = /[bcdfghjklmnpqrstvwxz]{5,}/i
    score += 1 if name.to_s.match?(suite) || body.to_s.match?(suite)

    # Meme suite de chiffres dans le nom ET dans le corps : identifiant de
    # campagne, pose par le robot pour relier l'envoi a la reception.
    score += 2 if (name.to_s.scan(/\d{4,}/) & body.to_s.scan(/\d{4,}/)).any?

    score
  end
end
