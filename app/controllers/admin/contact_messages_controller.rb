module Admin
  class ContactMessagesController < BaseController
    def index
      @filtre   = params[:filtre] == "indesirables" ? "indesirables" : "legitimes"
      @messages = ContactMessage.public_send(@filtre).order(created_at: :desc)
      @nb_ok    = ContactMessage.legitimes.count
      @nb_spam  = ContactMessage.indesirables.count
    end

    def destroy
      ContactMessage.find(params[:id]).destroy
      redirect_back fallback_location: admin_contact_messages_path, notice: "Message supprimé."
    end

    def purge
      nb = ContactMessage.indesirables.destroy_all.size
      redirect_to admin_contact_messages_path, notice: "#{nb} message(s) indésirable(s) supprimé(s)."
    end
  end
end
