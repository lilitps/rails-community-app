require 'test_helper'

class SiteFeedTest < ActionDispatch::IntegrationTest
  include PostsHelper
  include ActionView::Helpers::TextHelper

  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
  end

  test "should display first 3 posts on home page feed" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.pagination-sm', count: 1
    assert_select 'div#feed', count: 1
    assert_select 'a>img.gravatar', count: 0
    log_in_as(@non_admin)
    get root_path
    assert_select 'a>img.gravatar', count: 3
    assert_select '#feed>div>div>.thumbnail', count: 3
    first_page_of_feed = feed(1)
    assert_not first_page_of_feed.empty?
    first_page_of_feed.each do |post|
      assert_select 'div#post-' + post.id.to_s, count: 1
      assert_match post.content, response.body
    end
    log_in_as(@admin)
    get root_path
    first_page_of_feed = feed(1)
    assert_not first_page_of_feed.empty?
    first_page_of_feed.each do |post|
      assert_select 'a[href=?]', post_path(post), text: 'delete'
    end
  end

  test "feed should have the right posts" do
    tina = users(:tina)
    # Posts from admin user only
    get root_path
    assert_template 'static_pages/home'
    @feed = assigns(:feed)
    assert_not @feed.empty?
    @feed.each do |post|
      assert_match auto_format_html(post.content), response.body
      assert post.user.admin
    end
    # Posts from admin user, logged in user and following users
    posts = posts(:most_recent, :orange, :tone)
    log_in_as(@non_admin)
    get root_path
    @feed = assigns(:feed)
    assert_not @feed.empty?
    posts.each do |post|
      assert @feed.include?(post)
      assert_match CGI.escapeHTML(post.content), response.body
    end
    # Posts from unfollowed user
    tina.posts.each do |post_unfollowed|
      assert_not @feed.include?(post_unfollowed)
    end
    # Posts from self
    posts = posts(:most_recent, :enthusiastic, :orange)
    log_in_as(tina)
    get root_path
    @feed = assigns(:feed)
    assert_not @feed.empty?
    posts.each do |post|
      assert @feed.include?(post)
      assert_match CGI.escapeHTML(post.content), response.body
    end
  end

  test "should render all image and edit modals for all posts" do
    # without log in
    get root_path
    assert_template 'static_pages/home'
    @feed = assigns(:feed)
    assert_not @feed.empty?
    assert_select '#all-modals', count: 1
    @feed.each do |post|
      assert_select '#image-modal-' + post.id.to_s, count: 1 if post.picture?
      assert_select '#imagePost' + post.id.to_s + 'ModalLabel', count: 1 if post.picture?
      assert_select '#imagePost' + post.id.to_s + 'ModalLabel', post.picture.file.basename if post.picture?
      assert_match post.picture.file.basename, response.body if post.picture?
      assert_select '#edit-post-modal-' + post.id.to_s, false, "home page must contain no modals"
    end
    # log in as non admin user
    log_in_as(@non_admin)
    get root_path
    assert_template 'static_pages/home'
    @feed = assigns(:feed)
    assert_not @feed.empty?
    assert_select '#all-modals', count: 1
    @feed.each do |post|
      assert_select '#image-modal-' + post.id.to_s, count: 1 if post.picture?
      assert_select '#edit-post-modal-' + post.id.to_s, false, "home page must contain no modals"
    end
    assert_select '#new-post-modal', false, "home page must contain no new post modal"
    # log in as admin user
    log_in_as(@admin)
    get root_path
    assert_template 'static_pages/home'
    @feed = assigns(:feed)
    assert_not @feed.empty?
    assert_select '#all-modals', count: 1
    @feed.each do |post|
      assert_select '#image-modal-' + post.id.to_s, count: 1 if post.picture?
      assert_select '#edit-post-modal-' + post.id.to_s, true, "home page must contain edit modals"
      assert_select '#editPost' + post.id.to_s + 'ModalLabel', count: 1
      assert_select '#editPost' + post.id.to_s + 'ModalLabel', 'Edit post...'
      assert_select '#edit_post_' + post.id.to_s, count: 1
    end
    assert_select '#new-post-modal', true, "home page must contain new post modal"
    assert_select '#editPostModalLabel', count: 1
    assert_select '#editPostModalLabel', 'Compose new post...'
    assert_select '#new_post', count: 1
  end

  test "should display first 3 facebook page posts on home page feed" do
    if Koala.config.app_id.present? && Koala.config.app_secret.present?
      get root_path
      assert_template 'static_pages/home'
      assert_select 'div#fb-feed', count: 1
      assert_select '#fb-feed>div>div>.thumbnail', count: 3
      feed = fb_feed
      assert_not feed.empty?
      feed.each do |post|
        assert_select 'div#post-' + post['id'], count: 1
        assert_match auto_format_html(post['message']), response.body
        assert_select 'a[href=?]', post['permalink_url']
      end
    end
  end
end
