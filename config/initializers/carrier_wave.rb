# frozen_string_literal: true

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/google' # required
    config.fog_credentials = {
      # Configuration for Google Drive
      provider: 'Google',
      google_storage_access_key_id: Rails.application.credentials.g_storage[:access_key],
      google_storage_secret_access_key: Rails.application.credentials.g_storage[:secret_key]
    }
    config.storage = :fog
    config.fog_directory = ENV['G_STORAGE_PICTURE_UPLOAD_DIRECTORY']
  end
end
