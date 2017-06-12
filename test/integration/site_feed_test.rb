require 'test_helper'

class SiteFeedTest < ActionDispatch::IntegrationTest

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
    first_page_of_feed = Post.includes(:user).where(users: {admin: true}).paginate(page: 1, per_page: 5)
    assert_not first_page_of_feed.empty?
    first_page_of_feed.each do |post|
      assert_select 'li#post-' + post.id.to_s, count: 1
      assert_match post.content, response.body
    end
    log_in_as(@admin)
    get root_path
    first_page_of_feed = Post.includes(:user).where(users: {admin: true}).paginate(page: 1, per_page: 5)
    assert_not first_page_of_feed.empty?
    first_page_of_feed.each do |post|
      assert_select 'a[href=?]', post_path(post), text: 'delete'
    end
  end
end
