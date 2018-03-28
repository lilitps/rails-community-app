# frozen_string_literal: true

# A mailer to send account activation and password reset mails
class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.contact_mailer.contact.subject
  #
  def contact(contact)
    @contact = contact
    contact_email = ENV['CONTACT_MAIL_TO']
    mail from: @contact.email,
         to: contact_email,
         reply_to: @contact.email,
         subject: t('contact_mailer.contact.subject', email: @contact.email) + ': ' + @contact.subject,
         message: @contact.message
  end
end
