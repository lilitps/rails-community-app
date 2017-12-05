# frozen_string_literal: true

# A static pages controller to manage static pages like home or contact page
class StaticPagesController < ApplicationController
  include PostsHelper

  def home
    @post = current_user.posts.build if can? :create, Post
    @feed = feed(params[:page])
    @fb_feed = fb_feed
  end

  def about; end

  def help; end
end
