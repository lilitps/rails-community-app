# frozen_string_literal: true

if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start "rails"
end

# Previous content of test helper now starts here

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"
require "authlogic/test_case"

module MiniTestWithBullet
  require "minitest/unit"

  def before_setup
    Bullet.start_request
    super if defined?(super)
  end

  def after_teardown
    super if defined?(super)
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end
end

module ActiveSupport
  # Adds more helper methods to be used by all tests
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
    include MiniTestWithBullet
    include ApplicationHelper
    parallelize(workers: :number_of_processors)

    if ENV["COVERAGE"]
      parallelize_setup do |worker|
        SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
      end

      parallelize_teardown do |worker|
        SimpleCov.result
      end
    end
    # Add more helper methods to be used by all tests here...
  end
end

module ActionDispatch
  # Adds more helper methods to be used by all tests
  class IntegrationTest
    include MiniTestWithBullet
    include UserSessionsHelper
    parallelize(workers: :number_of_processors)

    if ENV["COVERAGE"]
      parallelize_setup do |worker|
        SimpleCov.command_name "#{SimpleCov.command_name}-#{worker}"
      end

      parallelize_teardown do |worker|
        SimpleCov.result
      end
    end
    # Add more helper methods to be used by all tests here...

    # Log in as a particular user.
    def log_in_as(user, password: "password", remember_me: "1")
      post login_path, params: { user_session: { email: user.email,
                                                 password: password,
                                                 remember_me: remember_me } }
      @current_user_session = assigns(:current_user_session)
      @current_user = assigns(:current_user)
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
