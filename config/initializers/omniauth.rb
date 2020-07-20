Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, Koala.config.app_id, Koala.config.app_secret
end
