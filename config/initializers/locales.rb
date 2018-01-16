# frozen_string_literal: true

require 'i18n/backend/active_record'

# The locale-specific translations are stored in the translations table
translation = I18n::Backend::ActiveRecord::Translation

if translation.table_exists?
  I18n.backend = I18n::Backend::ActiveRecord.new

  I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
  I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Flatten)
  I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
  I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

  # Translations will be looked up first in the database, based on the key/locale combination.
  # If no match is found, the translation is looked up in the corresponding YML file.
  I18n.backend = I18n::Backend::Chain.new(I18n::Backend::Simple.new, I18n.backend)
end

I18n::Backend::Chain.send(:include, I18n::Backend::Fallbacks)

# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

# Whitelist locales available for the application
# Adds locales available for the application to scope in routes.rb
I18n.available_locales = %i[en de]

# Change the default locale for your Community App
I18n.default_locale = :en

# Whether the ActiveRecord backend should use destroy or delete when cleaning up internally.
I18n::Backend::ActiveRecord.configure do |config|
  config.cleanup_with_destroy = true # defaults to false
end
