class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :edit, :update, :destroy]
  before_action :admin_user, only: [:create]
  before_action :admin_user, :correct_user, only: [:edit, :update, :destroy]
  include PostsHelper

  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # POST	    /posts	        create	    posts_path
  # GET	      /posts/1/edit	  edit	      edit_post_path(post)	  page to edit post with id 1
  # PATCH	    /posts/1	      update	    post_path(post)	        update post
  # DELETE	  /posts/1	      destroy	    post_path(post)

  def create
    @post = current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        flash.now[:success] = t('post_created')
        @post = current_user.posts.build if logged_in?
        @feed = feed(params[:page])
        format.html {redirect_to root_url}
        format.js
      else
        @feed = []
        format.html {render 'static_pages/home'}
        format.js
      end
    end
  end

  def edit
    @post = Post.find(params[:id])
    respond_to do |format|
      format.html {redirect_to edit_post_path(@post)}
      format.js
    end
  end

  def update
    @post = Post.find(params[:id])
    respond_to do |format|
      if @post.update_attributes(post_params)
        flash.now[:success] = t('post_updated')
        format.html {redirect_back(fallback_location: root_url)}
        format.js
      else
        @feed = []
        format.html {render 'static_pages/home'}
        format.js
      end
    end
  end

  def destroy
    @destroedPostId = @post.id
    @post.destroy
    flash.now[:success] = t('post_deleted')
    @post = current_user.posts.build if logged_in? && current_user.admin?
    @feed = feed(params[:page])
    respond_to do |format|
      format.html {redirect_back(fallback_location: root_url)}
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :picture)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id]) if logged_in?
    redirect_to root_url if @post.nil?
  end
end
