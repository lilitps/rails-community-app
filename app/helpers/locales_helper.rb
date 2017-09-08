# frozen_string_literal: true

# Adds helper methods to be used in context of locales
module LocalesHelper
  # Remembers the user locale.
  def remember(locale)
    current_user.update_attributes(locale: locale) if logged_in?
    session[:locale] = locale
    I18n.locale = locale
  end
end
