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
end
