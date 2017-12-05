# frozen_string_literal: true

# A contacts controller to manage contact interface
class ContactsController < ApplicationController
  # GET /contacts/new
  def new
    @contact = Contact.new
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)
    if @contact.valid?
      flash[:success] = t('notices.success')
      ContactMailer.contact(@contact).deliver_now
      redirect_to root_path
    else
      flash[:error] = t('notices.error')
      render :new
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:name, :email, :subject, :message)
  end
end
