# frozen_string_literal: true

# Adds helper methods to be used in context of a contact
module ContactsHelper
  def about_chairman
    "#{t('community.about_board_of_directors_chairman')} : #{t('community.about_board_of_directors_chairman_name')}"
  end

  def about_vice_chairman
    "#{t('community.about_board_of_directors_vice_chairman')} : #{t('community.about_board_of_directors_vice_chairman_name')}"
  end

  def about_treasurer
    "#{t('community.about_board_of_directors_treasurer')} : #{t('community.about_board_of_directors_treasurer_name')}"
  end
end
