# frozen_string_literal: true

# This will stop BetterErrors from trying to render larger objects, which can cause
# slow loading times and browser performance problems. Stated size is in characters and refers
# to the length of #inspect's payload for the given object. Please be aware that HTML escaping
# modifies the size of this payload so setting this limit too precisely is not recommended.
if defined?(BetterErrors) && Rails.env.development?
  # default value: 100_000
  # credits to GitHub user bquorning, MIT License 2017: https://makandracards.com/makandra/46175-speed-up-better_errors
  module BetterErrorsHugeInspectWarning
    def inspect_value(obj)
      inspected = obj.inspect
      inspected = "Object was too large to inspect (#{inspected.size} bytes). " if inspected.size > 20_000
      CGI.escapeHTML(inspected)
    rescue NoMethodError
      "<span class='unsupported'>(object doesn't support inspect)</span>"
    rescue StandardError
      "<span class='unsupported'>(exception was raised in inspect)</span>"
    end
  end

  BetterErrors.ignored_instance_variables += %i[@_request @_assigns @_controller @view_renderer]
  BetterErrors::ErrorPage.prepend(BetterErrorsHugeInspectWarning)
end
