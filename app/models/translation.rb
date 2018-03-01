# frozen_string_literal: true

# A translation to store in the database
class Translation < ApplicationRecord
  validates :key, presence: true, uniqueness: true
end
