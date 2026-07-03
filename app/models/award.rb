class Award < ApplicationRecord
  has_one_attached :badge
  validates :title, presence: true
  scope :published, -> { where(published: true) }
end
