# frozen_string_literal: true

# A static pages controller to manage static pages like home or contact page
class StaticPagesController < ApplicationController
  include PostsHelper

  def home
    @post = current_user.posts.build if can? :create, Post
    @feed = feed(params[:page])
    @fb_feed = fb_feed
    flash.now[:warning] = t('warning.facebook.no_connection') unless @fb_feed
    @contact = Contact.new
  end

  def about; end

  def help; end

  def membership_application
    send_file(
      Rails.root.join('public', 'sifez-aufnahmeantrag.pdf'),
      type: 'application/pdf'
    )
  end
end
