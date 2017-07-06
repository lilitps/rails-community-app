class AccountActivationsController < ApplicationController
  # HTTP 	    URL	                                Action	    Named route	                          Purpose
  # request
  # GET	      /account_activation/<token>/edit	  edit	      edit_account_activation_url(token)
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t('account_activated')
      redirect_to user
    else
      flash[:danger] = t('invalid_activation_link')
      redirect_to root_url
    end
  end
end
