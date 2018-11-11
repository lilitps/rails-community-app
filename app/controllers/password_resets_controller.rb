# frozen_string_literal: true

# A password resets controller to reset and update users password
class PasswordResetsController < ApplicationController
  before_action :find_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  skip_authorization_check

  # HTTP       URL                            Action      Named route                        Purpose
  # request
  # GET       /password_resets/new            new         new_password_reset_path
  # POST      /password_resets                create      password_resets_path
  # GET       /password_resets/<token>/edit   edit        edit_password_reset_path(token)
  # PATCH     /password_resets/<token>        update      password_reset_path(token)
  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.send_password_reset_email
      flash[:info] = t('password_reset_email_sent')
      redirect_to root_path
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
    elsif @user.update(user_params)
      log_in @user
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

  # Confirms a valid user and checks expiration of token.
  def valid_user
    return if @user&.active? && User.find_using_perishable_token(params[:id])

    flash[:danger] = t('password_reset_has_expired')
    redirect_to root_path
  end
end
