# frozen_string_literal: true

# A users controller to manage users
class UsersController < ApplicationController
  before_action :require_user, except: %i[show new create]
  load_and_authorize_resource only: %i[index show new create edit update destroy following followers]

  # HTTP       URL                    Action      Named route              Purpose
  # request
  # GET        /users                index        users_path               page to list all users
  # GET        /users/1              show         user_path(user)          page to show user
  # GET        /users/new            new          new_user_path            page to make a new user (signup)
  # POST       /users                create       users_path               create a new user
  # GET        /users/1/edit         edit         edit_user_path(user)     page to edit user with id 1
  # PATCH      /users/1              update       user_path(user)          update user
  # DELETE     /users/1              destroy      user_path(user)          delete user

  # GET        /users/1/following    following    following_user_path(1)
  # GET        /users/1/followers    followers    followers_user_path(1)

  def index
    @users = @users.where(approved: true).page(params[:page])
  end

  def show
    redirect_to root_path && return unless @user.approved
    @feed = @user.posts.page(params[:page])
  end

  def new; end

  def create
    if verify_recaptcha(model: @user) && @user.save
      @user.send_activation_email
      flash[:info] = t("check_email_to_activate_account")
      redirect_to root_path
    else
      render "new"
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t("profile_updated", locale: @user.locale)
      redirect_to @user
    else
      render "edit"
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t("user_deleted")
    redirect_to users_path
  end

  def following
    @title = t("following")
    @users = @user.following.page(params[:page])
    render "show_follow"
  end

  def followers
    @title = t("followers")
    @users = @user.followers.page(params[:page])
    render "show_follow"
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
    end
end
