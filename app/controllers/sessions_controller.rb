class SessionsController < ApplicationController
  # Sessions a fully RESTful resource
  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # GET	      /login	      login_path	  new	                    page for a new session (login)
  # POST	    /login	      login_path	  create	                create a new session (login)
  # DELETE	  /logout	      logout_path	  destroy	                delete a session (log out)
  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message  = t('account_not_activated')
        message += t('check_email_to_activate_account')
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] = t('invalid_credentials')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
