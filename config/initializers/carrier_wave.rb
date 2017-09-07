if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/google' # required
    config.fog_credentials = {
      # Configuration for Google Drive
      provider: 'Google',
      google_storage_access_key_id: ENV['G_STORAGE_ACCESS_KEY'],
      google_storage_secret_access_key: ENV['G_STORAGE_SECRET_KEY']
    }
    config.storage = :fog
    config.fog_directory = ENV['G_STORAGE_PICTURE_UPLOAD_DIRECTORY']
  end
end
