# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'authlogic/test_case'
Minitest::Reporters.use!

module ActiveSupport
  # Adds more helper methods to be used by all tests
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    include ApplicationHelper
    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  # Adds more helper methods to be used by all tests
  class IntegrationTest
    include UserSessionsHelper
    # Add more helper methods to be used by all tests here...

    # Log in as a particular user.
    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { user_session: { email: user.email,
                                                 password: password,
                                                 remember_me: remember_me } }
    end

    # Returns true if a test user is logged in, false otherwise.
    def logged_in?
      session[:user_credentials].present?
    end

    # Log out the user.
    def log_out
      delete logout_path
    end
  end

  module Routing
    # Fixes the missing default locale problem in request specs.
    # See http://www.ruby-forum.com/topic/3448797
    # Adds more helper methods to be used by all tests
    class RouteSet
      # Include the locale params in every URL
      def default_url_options
        { locale: I18n.locale }
      end
    end
  end
end
