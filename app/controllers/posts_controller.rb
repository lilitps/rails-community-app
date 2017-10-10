# frozen_string_literal: true

# A posts controller to manage users posts interface
class PostsController < ApplicationController
  before_action :require_user
  authorize_resource only: :create
  load_and_authorize_resource only: %i[edit update destroy]

  include PostsHelper

  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # POST	    /posts	        create	    posts_path
  # GET	      /posts/1/edit	  edit	      edit_post_path(post)	  page to edit post with id 1
  # PATCH	    /posts/1	      update	    post_path(post)	        update post
  # DELETE	  /posts/1	      destroy	    post_path(post)

  def create
    @post = @current_user.posts.build(post_params)
    respond_to do |format|
      if @post.save
        flash.now[:success] = t('post_created')
        reset_feed
        format.html { redirect_to root_path }
      else
        @feed = []
        format.html { render 'static_pages/home' }
      end
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.html { redirect_to edit_post_path(@post) }
      format.js
    end
  end

  def update
    respond_to do |format|
      if @post.update_attributes(post_params)
        flash.now[:success] = t('post_updated')
        @feed = feed(params[:page])
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.html { render 'static_pages/home' }
      end
      format.js
    end
  end

  def destroy
    @post.destroy
    flash.now[:success] = t('post_deleted')
    reset_feed
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

  def post_params
    params.require(:post).permit(:content, :picture)
  end

  def reset_feed
    @post = @current_user.posts.build if logged_in? && @current_user.admin?
    @feed = feed(params[:page])
  end
end
