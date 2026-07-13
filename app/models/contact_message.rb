class ContactMessage < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 120 }
  validates :email, presence: true, length: { maximum: 200 },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :body,  presence: true, length: { maximum: 5000 }
end
