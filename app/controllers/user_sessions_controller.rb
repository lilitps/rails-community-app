# frozen_string_literal: true

# A sessions controller to remember user after log in
class UserSessionsController < ApplicationController
  before_action :require_no_user, only: %i[new create]
  before_action :require_user, only: :destroy
  load_and_authorize_resource only: :new
  authorize_resource only: %i[create destroy]

  # Sessions a fully RESTful resource
  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # GET	      /login	      login_path	  new	                    page for a new session (login)
  # POST	    /login	      login_path	  create	                create a new session (login)
  # DELETE	  /logout	      logout_path	  destroy	                delete a session (log out)
  def new; end

  def create
    # converts the ActionController::Parameters to a Hash.
    # FixMe: https://github.com/binarylogic/authlogic/pull/560
    @user_session = UserSession.new(user_session_params.to_h)
    if @user_session.save
      if current_user.approved?
        redirect_back_or current_user
      else
        process_with_warning_message
      end
    else
      flash.now[:danger] = t('invalid_credentials')
      render 'new'
    end
  end

  def destroy
    current_user_session&.destroy
    redirect_to root_path
  end

  private

  def process_with_warning_message
    message  = t('account_not_activated')
    message += t('check_email_to_activate_account')
    flash[:warning] = message
    redirect_to root_path
  end

  def user_session_params
    params.require(:user_session).permit(:email, :password, :remember_me)
  end
end
