# frozen_string_literal: true

# Top level controller adds settings and methods for all application controllers
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  check_authorization
  include UserSessionsHelper
  helper_method :log_in, :log_out, :current_user?, :current_user_session, :current_user

  protected

  # Because Authlogic introduces its own methods for storing user sessions,
  # the CSRF (Cross Site Request Forgery) protection that is built into Rails will not work out of the box.
  def handle_unverified_request
    current_user_session&.destroy
    redirect_to root_path
  end

  private

  # Handle Unauthorized Access
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_path, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
      format.any  { raise exception }
    end
  end

  # Logs in the given user and remembers in a persistent session.
  def log_in(user)
    UserSession.new(user).save
  end

  # Logs out the current user and forgets a persistent session.
  def log_out
    current_user_session&.destroy
    @current_user = nil
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns the current user session (if any).
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  # Returns the current logged-in user (if any).
  def current_user
    @current_user ||= current_user_session&.user
  end

  # Before filters

  # Confirms a logged-in user.
  def require_user
    return if current_user

    store_location
    flash[:notice] = t('please_log_in')
    redirect_to login_path
  end

  def require_no_user
    return unless current_user

    store_location
    flash[:notice] = t('please_log_out')
    redirect_to root_path
  end

  # Managing the Locale across Requests
  def set_locale
    I18n.locale = current_user&.locale ||
                  session[:locale] ||
                  http_accept_language.preferred_language_from(I18n.available_locales) ||
                  I18n.default_locale
  end

  # Confirms an admin user.
  def admin_user
    redirect_to root_path unless current_user&.admin?
  end

  # Include the locale params in every URL
  def default_url_options
    { locale: I18n.locale }
  end
end
