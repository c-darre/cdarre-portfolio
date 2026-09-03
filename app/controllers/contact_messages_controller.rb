class ContactMessagesController < ApplicationController
  SEL = "contact_form".freeze

  rate_limit to: 5, within: 1.hour, only: :create,
             with: -> { redirect_back fallback_location: root_path, alert: "Trop d'envois. Réessayez plus tard." }

  def create
    # Honeypot : champ invisible pour un humain ; rempli = robot.
    # On simule le succes sans rien enregistrer.
    if params[:website].present?
      redirect_back fallback_location: root_path, notice: "Message envoyé. Merci !"
      return
    end

    @message = ContactMessage.new(message_params)
    @message.spam = ContactMessage.spam_score(
      name: @message.name, email: @message.email,
      body: @message.body, secondes: secondes_de_remplissage
    ) >= ContactMessage::SEUIL

    if @message.save
      ContactMailer.new_message(@message).deliver_later unless @message.spam?
      redirect_back fallback_location: root_path,
                    notice: "Message envoyé. Merci, je reviens vers vous rapidement."
    else
      redirect_back fallback_location: root_path,
                    alert: "Envoi impossible : #{@message.errors.full_messages.to_sentence}"
    end
  end

  private

  # Horodatage signe pose a l'affichage du formulaire. Illisible et infalsifiable
  # cote client. Absent ou invalide : traite comme suspect, pas comme refus.
  def secondes_de_remplissage
    emis = Rails.application.message_verifier(SEL).verify(params[:ts])
    Time.current.to_i - emis.to_i
  rescue ActiveSupport::MessageVerifier::InvalidSignature, TypeError
    nil
  end

  def message_params
    params.require(:contact_message).permit(:name, :email, :body)
  end
end
