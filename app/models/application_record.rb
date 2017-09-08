# frozen_string_literal: true

# Top level abstract class for all models
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
