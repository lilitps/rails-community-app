# frozen_string_literal: true

require "test_helper"

# Tests rendering of modals for feed on home page if any post has image and user is an admin
class SiteFeedModalsTest < ActionDispatch::IntegrationTest
  include PostsHelper

  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
    @post = posts(:orange)
  end

  test "should render all posts with image and without edit modals for all posts if not logged in" do
    # without log in
    get root_path
    assert_template "static_pages/home"
    @feed = assigns(:feed)
    assert_not @feed.empty?
    assert_select "#all-modals", count: 1
    @feed.each do |post|
      assert_select "#image-modal-#{post.id}", count: 1 if post.picture?
      assert_select "#imagePost#{post.id}ModalLabel", count: 1 if post.picture?
      assert_select "#imagePost#{post.id}ModalLabel", post.picture.file.basename if post.picture?
      assert_match post.picture.file.basename, response.body if post.picture?
      assert_select "#edit-post-#{post.id}-modal", false, "home page must contain no modals"
    end
  end

  test "should render all posts with image and without edit modals for all posts if logged in as non admin" do
    # log in as non admin user
    log_in_as(@non_admin)
    assert logged_in?
    get root_path
    assert_template "static_pages/home"
    @feed = assigns(:feed)
    assert_not @feed.empty?
    assert_select "#all-modals", count: 1
    @feed.each do |post|
      assert_select "#image-modal-#{post.id}", count: 1 if post.picture?
      assert_select "#edit-post-#{post.id}-modal", false, "home page must contain no modals"
    end
    assert_select "#create-new-post-modal", false, "home should not contain a create new post modal"
  end

  test "should render all posts with image and edit modals for all posts if logged in as admin" do
    # log in as admin user
    log_in_as(@admin)
    assert logged_in?
    assert @current_user.admin?
    get root_path
    assert_template "static_pages/home"
    @feed = assigns(:feed)
    assert_not @feed.empty?
    assert_select "#all-modals", count: 1
    @feed.each do |post|
      assert_select "#image-modal-#{post.id}", count: 1 if post.picture?
      assert_select "#edit-post-#{post.id}-modal", true, "home page must contain edit modals"
      assert_select "#editPost#{post.id}ModalLabel", count: 1
      assert_select "#editPost#{post.id}ModalLabel", "Edit post..."
      assert_select "#edit_post_#{post.id}", count: 1
    end
    assert_select "#create-new-post-modal", true, "home page must contain a create new post modal"
    assert_select "#createNewPostModalLabel", count: 1
    assert_select "#createNewPostModalLabel", "Compose new post..."
    assert_select "#new_post", count: 1
  end
end
