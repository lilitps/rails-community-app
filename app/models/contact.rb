# frozen_string_literal: true

# A contact message from a user
class Contact
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :email, :subject, :message

  validates :name, presence: true
  validates :email, format: { with: Authlogic::Regex.email_nonascii }, presence: true
  validates :subject, presence: true
  validates :message, presence: true

  def initialize(attributes = {})
    attributes.each do |key, value|
      send("#{key}=", value)
    end
  end
end
