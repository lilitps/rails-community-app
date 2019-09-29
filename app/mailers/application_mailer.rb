# frozen_string_literal: true

# Top level class for all mailer
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout "mailer"
end
