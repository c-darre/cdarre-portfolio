class AdminUser < ApplicationRecord
  # Pas de :registerable (aucune inscription publique) ni de :trackable/:confirmable
  # (inutiles pour un back-office mono-utilisateur).
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
end
