# Where the I18n library should search for translation files
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

# Whitelist locales available for the application
# Adds locales available for the application to scope in routes.rb
I18n.available_locales = [:en, :de]

# Change the default locale for your Community App
I18n.default_locale = :en