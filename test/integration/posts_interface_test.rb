require 'test_helper'

class PostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:lana)
    @non_admin = users(:archer)
  end

  test "post interface" do
    log_in_as(@non_admin)
    get root_path
    assert_select 'div.pagination'
    # Invalid submission
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    log_in_as(@admin)
    get root_path
    assert_select 'input[type=file]'
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "" } }
    end
    assert_select 'div#error_explanation'
    # Valid submission (only admin)
    content = "This post really ties the room together"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: { content: content, picture: picture } }
    end
    assert @admin.posts.first.picture?
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # Delete post
    assert_select 'a', text: 'delete'
    first_post = @admin.posts.paginate(page: 1).first
    assert_difference 'Post.count', -1 do
      delete post_path(first_post)
    end
    # Visit different user as admin
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 2
    # Visit different user as non admin (no delete links)
    log_in_as(@non_admin)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
