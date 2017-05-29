class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  include PostsHelper

  # HTTP 	    URL	            Action	    Named route	            Purpose
  # request
  # POST	    /posts	      create	      posts_path
  # DELETE	  /posts/1	    destroy	      post_path(post)

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      @posts = load_posts(params[:page])
      render 'static_pages/home'
    end
  end

  def destroy
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
