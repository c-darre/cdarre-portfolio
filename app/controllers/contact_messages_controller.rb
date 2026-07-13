class ContactMessagesController < ApplicationController
  # Rate-limiting natif Rails 8 (compteur en cache : inerte en dev sans cache, actif en prod).
  rate_limit to: 5, within: 1.hour, only: :create,
             with: -> { redirect_back fallback_location: root_path, alert: "Trop d'envois. Réessayez plus tard." }

  def create
    # Honeypot : champ invisible pour un humain ; rempli = robot.
    # On simule le succès sans rien enregistrer (ne pas renseigner le spammeur).
    if params[:website].present?
      redirect_back fallback_location: root_path, notice: "Message envoyé. Merci !"
      return
    end

    @message = ContactMessage.new(message_params)
    if @message.save
      redirect_back fallback_location: root_path,
                    notice: "Message envoyé. Merci, je reviens vers vous rapidement."
    else
      redirect_back fallback_location: root_path,
                    alert: "Envoi impossible : #{@message.errors.full_messages.to_sentence}"
    end
  end

  private

  def message_params
    params.require(:contact_message).permit(:name, :email, :body)
  end
end
