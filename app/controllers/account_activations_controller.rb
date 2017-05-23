class AccountActivationsController < ApplicationController
  # Users a fully RESTful resource
  # HTTP 	    URL	                                Action	    Named route	                          Purpose
  # request
  # GET	      /account_activation/<token>/edit	  edit	      edit_account_activation_url(token)
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
