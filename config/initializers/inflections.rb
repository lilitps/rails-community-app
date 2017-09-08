# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end

# Inflections for de
ActiveSupport::Inflector.inflections(:de) do |inflect|
  # rubocop:disable Style/AsciiComments
  inflect.clear

  # Pluralendung n/en
  # inflect.plural /(ent)$/i, 'enten'
  # inflect.singular /(enten)$/i, 'ent'
  # inflect.plural /(e|in|ion|ik|heit|keit|schaft|tät|ung)$/i, 'ionen'
  # inflect.singular /(ionen)$/i, 'ion'

  inflect.irregular 'Beitrag', 'Beiträge'
  inflect.irregular 'Fehler', 'Fehler'
  # rubocop:enable Style/AsciiComments
end
