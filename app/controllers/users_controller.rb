class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:index, :destroy]

  # HTTP 	    URL	                  Action	    Named route	            Purpose
  # request
  # GET	      /users	              index	      users_path	            page to list all users
  # GET	      /users/1	            show	      user_path(user)	        page to show user
  # GET	      /users/new	          new	        new_user_path	          page to make a new user (signup)
  # POST	    /users	              create	    users_path	            create a new user
  # GET	      /users/1/edit	        edit	      edit_user_path(user)	  page to edit user with id 1
  # PATCH	    /users/1	            update	    user_path(user)	        update user
  # DELETE	  /users/1	            destroy	    user_path(user)	        delete user

  # GET	      /users/1/following	  following	  following_user_path(1)
  # GET	      /users/1/followers	  followers	  followers_user_path(1)

  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    redirect_to root_url and return unless @user.activated
    @feed = @user.posts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t('check_email_to_activate_account')
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = t('profile_updated', locale: @user.locale)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = t('user_deleted')
    redirect_to users_url
  end

  def following
    @title = t('following')
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = t('followers')
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :locale)
  end

  # Before filters

  # Confirms the correct user.
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
