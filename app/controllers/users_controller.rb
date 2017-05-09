class UsersController < ApplicationController
  # Users a fully RESTful resource
  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # GET	      /users	        index	      users_path	            page to list all users
  # GET	      /users/1	      show	      user_path(user)	        page to show user
  # GET	      /users/new	    new	        new_user_path	          page to make a new user (signup)
  # POST	    /users	        create	    users_path	            create a new user
  # GET	      /users/1/edit	  edit	      edit_user_path(user)	  page to edit user with id 1
  # PATCH	    /users/1	      update	    user_path(user)	        update user
  # DELETE	  /users/1	      destroy	    user_path(user)	        delete user

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Community App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
