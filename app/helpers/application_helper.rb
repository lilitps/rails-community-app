# frozen_string_literal: true

# Adds helper methods to be used in context of this application
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = "")
    base_title = I18n.t("community.name")
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  # Returns the Site verification token for Google Suite
  def google_suite_verification
    google_suite_verification = Rails.application.credentials
                                     .g_site[:verification]
    "no_google_suite_verification" if google_suite_verification.empty?
  end

  # Checks if the expiry date is reached or note
  def expiry_date_past?
    Date.parse(ENV["IDEALO_CONSULTATION_EXPIRY_DATE"]).past?
  end

  # creates mailto community link
  def mail_to_community
    mail_to ENV["CONTACT_MAIL_TO"], nil,
            subject: "#{t('page_title.imprint')} #{t('community.name')}"
  end

  # For prevent an error "incompatible character encodings: ASCII-8BIT and
  # UTF-8" and "can't modify frozen string" for encoding a varible
  def address_of_the_organization
    address_of_the_organization = ENV["ADDRESS_OF_THE_ORGANIZATION"]
                                  .dup
                                  .force_encoding(Encoding::UTF_8)
    address_of_the_organization.html_safe # rubocop:disable Rails/OutputSafety
  end
end
