require 'test_helper'

class SiteFeedTest < ActionDispatch::IntegrationTest

  test "display first 5 posts on home page feed" do
    get root_path
    assert_template 'static_pages/home'
    assert_select 'div.pagination', count: 1
    assert_select 'ol.feed', count: 1
    assert_select 'a>img.gravatar', count: 5
    Post.all.paginate(page: 1, per_page: 5).each do |post|
      assert_select 'li#post-' + post.id.to_s, count: 1
      assert_match post.content, response.body
    end
  end
end
