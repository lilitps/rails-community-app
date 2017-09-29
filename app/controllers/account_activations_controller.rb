# frozen_string_literal: true

# An account activations controller to activate users accounts
class AccountActivationsController < ApplicationController
  before_action :find_user, only: %i[edit]

  # HTTP 	    URL	                                Action	    Named route	                          Purpose
  # request
  # GET	      /account_activation/<token>/edit	  edit	      edit_account_activation_path(token)
  def edit
    if valid_user
      @user.activate
      log_in @user
      flash[:success] = t('account_activated')
      redirect_to @user
    else
      flash[:danger] = t('invalid_activation_link')
      redirect_to root_url
    end
  end

  private

  # Before filters
  def find_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    @user && !@user.active? && User.find_using_perishable_token(params[:id])
  end
end
