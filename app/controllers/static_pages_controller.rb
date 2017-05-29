class StaticPagesController < ApplicationController
  include PostsHelper

  def home
    @post = current_user.posts.build if logged_in?
    @posts = load_posts(params[:page])
  end

  def about
  end

  def contact
  end

  def help
  end
end
