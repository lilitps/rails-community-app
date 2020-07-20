class OmniauthSessionsController < ApplicationController
  def create
    if auth_hash = request.env["omniauth.auth"]
      @current_user_session = UserSession.new(User.sign_in_from_omniauth(auth_hash))
      redirect_back_or current_user
    else
      redirect_to login_path
    end
  end
end
