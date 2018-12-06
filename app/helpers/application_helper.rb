# frozen_string_literal: true

# Adds helper methods to be used in context of this application
module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = I18n.t('community.name')
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  # creates mailto community link
  def mail_to_community
    mail_to ENV['CONTACT_MAIL_TO'], nil, subject: "#{t('page_title.imprint')} #{t('community.name')}"
  end

  # For prevent an error "incompatible character encodings: ASCII-8BIT and UTF-8" and
  # "can't modify frozen string" for encoding a varible
  def address_of_the_organization
    ENV['ADDRESS_OF_THE_ORGANIZATION'].dup.force_encoding(Encoding::UTF_8).html_safe
  end

  # creates btn with glyphicon icon.
  # Do not forget to call .html_safe in your templates
  def glyphicon_btn(pull_right: true, glyphicon: :plus, btn_text: 'Add')
    span = "<span class=\""
    span += 'pull-right ' if pull_right
    span += 'btn '
    span += (glyphicon == :plus) ? 'glyphicon-btn-blue ' : 'glyphicon-btn-red '
    span += 'btn-md glyphicon glyphicon-' + glyphicon.to_s
    span + "\" aria-label=\"" + btn_text + "\"></span>"
  end
end
