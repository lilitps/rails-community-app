# frozen_string_literal: true

# Adds helper methods to be used in context of a contact
module ContactsHelper
  def about_chairman
    "#{t('community.about_board_of_directors_chairman')} : #{ENV['CHAIRMAN_NAME']}"
  end

  def about_vice_chairman
    "#{t('community.about_board_of_directors_vice_chairman')} : #{ENV['VICE_CHAIRMAN_NAME']}"
  end

  def about_treasurer
    "#{t('community.about_board_of_directors_treasurer')} : #{ENV['TREASURER_NAME']}"
  end
end
