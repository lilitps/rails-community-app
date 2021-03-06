# frozen_string_literal: true

require "koala"
require "auto_html"

# Adds helper methods to be used in context of a post
module PostsHelper
  include UserSessionsHelper

  FB_POST_FIELDS = %w[id type icon story name message
                      permalink_url link full_picture
                      description created_time].freeze

  # Returns the feed title.
  def feed_title(feed_title = "")
    if feed_title.empty?
      I18n.t("feed_header")
    else
      feed_title
    end
  end

  # Returns most recent posts per page
  def feed(page = 1, per_page = 3, only_admin = true)
    query = Post.includes(:user).where(users: { admin: only_admin })
    if current_user
      following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
      query = query.or(Post.includes(:user)
                         .where(users: { admin: !only_admin })
                         .where("user_id IN (#{following_ids}) OR user_id = :user_id",
                                user_id: current_user.id))
    end
    query.page(page).per(per_page)
  end

  # Returns the feed of posts (including status updates) and links published by this page, or by others on this page.
  # https://developers.facebook.com/docs/graph-api/reference/v3.2/page/feed#read
  def fb_feed(limit = 3)
    @fb_client ||= facebook_app_client
    if @fb_client
      @fb_client&.get_connection(ENV["FB_PAGE_ID"],
                                 "feed",
                                 limit: limit,
                                 fields: PostsHelper::FB_POST_FIELDS,
                                 locale: I18n.locale,
                                 return_ssl_resources: true
                                )
    else
      []
    end
  rescue Koala::Facebook::ClientError => e
    Rails.logger.error e.message # TODO: need some failure handling
    []
  end

  # Returns a composition of filters that transforms input by passing the output
  # of one filter as input for the next filter in line.
  #
  # Note that the order of filters is important - ie you want 'Image' before
  # 'Link' filter so that URL of the image gets transformed to
  # 'img' tag and not 'a' tag.
  def format_pipeline
    AutoHtml::Pipeline
      .new(AutoHtml::Image.new,
           AutoHtml::Link.new(target: "_blank", rel: "noopener"))
  end

  # Returns simple format of text with html tags
  def auto_format_html(text)
    simple_format format_pipeline.call(text)
  end

  private
    # Log in to facebook app and get app client with authentication
    # https://github.com/arsduo/koala/wiki/Graph-API
    def facebook_app_client
      return unless Koala.config.app_id.present? && Koala.config.app_secret.present?

      # application-access-tokens don't expire, but you can still get the hash with get_app_access_token_info
      # https://github.com/arsduo/koala/wiki/OAuth#application-access-tokens
      oauth = Koala::Facebook::OAuth.new
      oauth_token = oauth&.get_app_access_token
    rescue Koala::Facebook::OAuthTokenRequestError, Faraday::ConnectionFailed, SocketError => e
      Rails.logger.error e.message # TODO: need some failure handling
      nil
    else
      Koala::Facebook::API.new(oauth_token)
    end
end
