# frozen_string_literal: true

# A locales controller to set and update application language for users
class LocalesController < ApplicationController

  include LocalesHelper

  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # PATCH	    /locales/	      update	    locale_path(local)

  def update
    remember(params[:locale])
    flash[:success] = t('locale_set_to', language: t('language_name'))
    redirect_to root_path
  end

  private

  # Remembers the user locale.
  def remember(locale)
    current_user&.update_attributes(locale: locale)
    session[:locale] = locale
    I18n.locale = locale
  end
end
