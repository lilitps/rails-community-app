# frozen_string_literal: true

require 'koala'
require 'auto_html'

# Adds helper methods to be used in context of a post
module PostsHelper
  include SessionsHelper

  # Returns most recent posts per page
  def feed(page, per_page = 3, only_admin = true)
    query = Post.includes(:user).where(users: { admin: only_admin })
    if logged_in?
      following_ids = 'SELECT followed_id FROM relationships WHERE  follower_id = :user_id'
      query = query.or(Post.includes(:user)
                           .where(users: { admin: !only_admin })
                           .where("user_id IN (#{following_ids}) OR user_id = :user_id",
                                  user_id: current_user.id))
    end
    query.paginate(page: page, per_page: per_page)
  end

  # Returns most recent posts from facebook page
  def fb_feed(limit = 3)
    fields = %w[id type icon story name message permalink_url link full_picture description created_time]
    facebook_app_client&.get_connection(ENV['MY_PAGE_ID'],
                                        'posts',
                                        {
                                          limit: limit,
                                          fields: fields,
                                          locale: I18n.locale,
                                          return_ssl_resources: true
                                        })
  end

  # Returns a composition of filters that transforms input by passing the output
  # of one filter as input for the next filter in line.
  #
  # Note that the order of filters is important - ie you want 'Image' before 'Link' filter
  # so that URL of the image gets transformed to 'img' tag and not 'a' tag.
  def format_pipeline
    AutoHtml::Pipeline.new(AutoHtml::Image.new, AutoHtml::Link.new(target: '_blank'))
  end

  # Returns simple format of text with html tags
  def auto_format_html(text)
    simple_format format_pipeline.call(text)
  end

  private

  # Log in to facebook app and get app client with authentication
  def facebook_app_client
    return unless Koala.config.app_id.present? && Koala.config.app_secret.present?
    oauth = Koala::Facebook::OAuth.new(ENV['MY_APP_ID'], ENV['MY_APP_SECRET'])
    oauth_token = oauth&.get_app_access_token
    Koala::Facebook::API.new(oauth_token)
  end
end
