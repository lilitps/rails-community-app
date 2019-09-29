# frozen_string_literal: true

# A contacts controller to manage contact interface
class ContactsController < ApplicationController
  skip_authorization_check
  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    respond_to do |format|
      if @contact.valid? && verify_recaptcha(model: @contact)
        flash.now[:success] = t("notices.success")
        ContactMailer.contact(@contact).deliver_now
        @contact = Contact.new
        format.html { redirect_to root_path }
      else
        flash.now[:error] = t("notices.error")
        format.html { render :new }
      end
      format.js
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :email, :subject, :message)
    end
end
