# frozen_string_literal: true

require 'test_helper'

# Tests feed on home page
class SiteFeedTest < ActionDispatch::IntegrationTest
  include PostsHelper
  include ActionView::Helpers::TextHelper

  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
  end

  test 'should display first 3 posts on home page feed without gravatar if not logged in' do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.pagination-sm', count: 1
    assert_select 'div#feed', count: 1
    assert_select 'a>img.gravatar', count: 0
  end

  test 'should display first 3 posts on home page feed with gravatar if logged in' do
    log_in_as(@non_admin)
    assert logged_in?
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a>img.gravatar', count: 3
    assert_select '#feed>div>div>.thumbnail', count: 3
    @first_page_of_feed = assigns(:feed)
    assert_not @first_page_of_feed.empty?
    @first_page_of_feed.each do |post|
      assert_select 'div#post-' + post.id.to_s, count: 1
      assert_match post.content, response.body
    end
  end

  test 'should display first 3 posts on home page feed with gravatar and admin links if logged in as admin' do
    log_in_as(@admin)
    assert logged_in?
    assert @current_user.admin?
    get root_path
    assert_template 'static_pages/home'
    @first_page_of_feed = assigns(:feed)
    assert_not @first_page_of_feed.empty?
    @first_page_of_feed.each do |post|
      assert_select 'a[href=?]', edit_post_path(post), text: 'edit'
      assert_select 'a[href=?]', post_path(post), text: 'delete'
    end
  end

  test 'should display posts with read more link' do
    log_in_as(@non_admin)
    get root_path
    assert_template 'static_pages/home'
    @first_page_of_feed = assigns(:feed)
    assert_not @first_page_of_feed.empty?
    @first_page_of_feed.each do |post|
      if post.content.present? && post.content.length > 150
        assert_match auto_format_html(truncate(post.content, length: 150)), response.body
        assert_select '.read-more-' + post.id, count: 1
      else
        assert_match auto_format_html(post.content), response.body
      end
    end
  end

  test 'for not logged in user feed should have admin only posts' do
    # Posts from admin user only
    get root_path
    assert_template 'static_pages/home'
    @feed = assigns(:feed)
    assert_not @feed.empty?
    @feed.each do |post|
      assert_match auto_format_html(post.content), response.body
      assert post.user.admin
    end
  end

  test 'for logged in users feed should have user, following users and admin posts' do
    # Posts from admin user, logged in user and following users
    log_in_as(@non_admin)
    assert logged_in?
    posts = posts(:most_recent, :orange, :tone)
    get root_path
    @feed = assigns(:feed)
    assert_not @feed.empty?
    posts.each do |post|
      assert @feed.include?(post)
      assert_match CGI.escapeHTML(post.content), response.body
    end
    # Posts from unfollowed user
    tina = users(:tina)
    tina.posts.each do |post_unfollowed|
      assert_not @feed.include?(post_unfollowed)
    end
    log_out
    # Posts from self
    log_in_as(tina)
    assert logged_in?
    posts = posts(:most_recent, :enthusiastic, :orange)
    get root_path
    @feed = assigns(:feed)
    assert_not @feed.empty?
    posts.each do |post|
      assert @feed.include?(post)
      assert_match CGI.escapeHTML(post.content), response.body
    end
  end
end
