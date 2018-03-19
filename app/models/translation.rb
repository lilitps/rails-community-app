# frozen_string_literal: true

# == Schema Information
#
# Table name: translations
#
#  id             :integer          not null, primary key
#  locale         :string           not null
#  key            :string           not null
#  value          :text             not null
#  interpolations :text
#  is_proc        :boolean          default(FALSE)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_translations_on_key     (key)
#  index_translations_on_locale  (locale)
#

# A translation to store in the database
class Translation < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end
