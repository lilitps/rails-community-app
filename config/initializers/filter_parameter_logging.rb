# Be sure to restart your server when you modify this file.

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[ password
                                                  password_confirmation
                                                  appsecret_proof
                                                  client_secret
                                                  access_token
                                                  perishable_token]

# it's desirable to filter out from log files some sensitive locations your application is redirecting to
Rails.application.config.filter_redirect += %i[]
