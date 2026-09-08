# Applique les durées de conservation annoncées dans la politique de
# confidentialité. Toute modification ici doit être reportée dans
# app/views/pages/privacy.html.erb, et inversement.
class PurgeContactMessagesJob < ApplicationJob
  queue_as :default

  CONSERVATION_LEGITIMES    = 12.months
  CONSERVATION_INDESIRABLES = 30.days

  def perform
    ContactMessage.indesirables
                  .where(created_at: ..CONSERVATION_INDESIRABLES.ago)
                  .delete_all

    ContactMessage.legitimes
                  .where(created_at: ..CONSERVATION_LEGITIMES.ago)
                  .delete_all
  end
end
