require 'test_helper'

class SiteFeedTest < ActionDispatch::IntegrationTest
  include PostsHelper

  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
  end

  test "should display first 5 posts on home page feed" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.pagination', count: 1
    assert_select 'ol.feed', count: 1
    assert_select 'a>img.gravatar', count: 0
    log_in_as(@non_admin)
    get root_path
    assert_select 'a>img.gravatar', count: 5
    first_page_of_feed = feed(1)
    assert_not first_page_of_feed.empty?
    first_page_of_feed.each do |post|
      assert_select 'li#post-' + post.id.to_s, count: 1
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
      assert_match CGI.escapeHTML(post.content), response.body
      assert post.user.admin
    end
    # Posts from admin user, logged in user and following users
    posts = posts(:most_recent, :orange, :tone, :cat_video, :van)
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
    posts = posts(:most_recent, :enthusiastic, :orange, :cat_video, :future)
    log_in_as(tina)
    get root_path
    @feed = assigns(:feed)
    assert_not @feed.empty?
    posts.each do |post|
      assert @feed.include?(post)
      assert_match CGI.escapeHTML(post.content), response.body
    end
  end
end
