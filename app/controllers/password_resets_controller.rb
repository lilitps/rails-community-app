# frozen_string_literal: true

# A password resets controller to reset and update users password
class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  # HTTP 	    URL	                          Action	    Named route	                      Purpose
  # request
  # GET	    /password_resets/new	          new	        new_password_reset_path
  # POST	  /password_resets	              create	    password_resets_path
  # GET	    /password_resets/<token>/edit	  edit	      edit_password_reset_path(token)
  # PATCH	  /password_resets/<token>	      update	    password_reset_url(token)
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t('password_reset_email_sent')
      redirect_to root_url
    else
      flash.now[:danger] = t('email_address_not_found')
      render 'new'
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t('errors.can_not_be_empty'))
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      @user.update_attributes(reset_digest: nil)
      flash[:success] = t('password_has_been_reset')
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  # Before filters
  def find_user
    @user = User.find_by(email: params[:email])
  end

  # Confirms a valid user.
  def valid_user
    return if @user && @user.activated? && @user.authenticated?(:reset, params[:id])
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t('password_reset_has_expired')
    redirect_to new_password_reset_url
  end
end
