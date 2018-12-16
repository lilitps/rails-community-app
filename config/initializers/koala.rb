# frozen_string_literal: true

Koala.configure do |config|
  config.app_id = Rails.application.credentials[Rails.env.to_sym][:fb][:app_id]
  config.app_secret = Rails.application.credentials[Rails.env.to_sym][:fb][:app_secret]
  # See Koala::Configuration for more options, including details on how to send requests through
  # your own proxy servers.
end

# enable logging
Koala::Utils.level = Logger::DEBUG if Rails.env.development?
