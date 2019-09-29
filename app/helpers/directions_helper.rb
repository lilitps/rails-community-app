# frozen_string_literal: true

# Adds helper methods to be used in context of a contact
module DirectionsHelper
  # Integrate the Google Maps API v3
  # https://developers.google.com/maps/documentation/javascript/adding-a-google-map
  # see further google_maps.coffee

  # take care to use the init google maps coffee script before the google maps script tag
  # returns the src string to get access to the dynamic (Java Script) map API.
  def google_dynamic_js_map
    "#{google_maps_api_url}/api/js?key=#{google_maps_api_key}&language=#{I18n.locale}&callback=initGoogleMap"
  end

  private
    # returns the google maps api key
    def google_maps_api_key
      Rails.application.credentials.g_maps[:api_key]
    end

    # returns the API url from the Google Maps API v3
    def google_maps_api_url
      "https://maps.googleapis.com/maps"
    end
end
