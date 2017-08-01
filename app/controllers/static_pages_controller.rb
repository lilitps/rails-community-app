class StaticPagesController < ApplicationController
  include PostsHelper

  def home
    @post = current_user.posts.build if logged_in?
    @feed = feed(params[:page])
    @fb_feed = fb_feed
  end

  def about
  end

  def contact
  end

  def help
  end
end
