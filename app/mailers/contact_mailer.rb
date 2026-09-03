class ContactMailer < ApplicationMailer
  def new_message(contact_message)
    @message = contact_message
    mail(
      to: ENV.fetch("CONTACT_NOTIFY_TO", "cyprien.darre@gmail.com"),
      from: ENV.fetch("SMTP_USER", "cyprien.darre@gmail.com"),
      reply_to: @message.email,
      subject: "cdarre.fr — message de #{@message.name}"
    )
  end
end
